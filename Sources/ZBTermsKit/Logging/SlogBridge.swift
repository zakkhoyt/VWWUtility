import Foundation
import SwiftyShell

/// Bridges Swift logging calls to the `slog_*` family of Zsh shell functions.
///
/// Because `slog_*` are Zsh shell functions (not binaries), they must be sourced before use.
/// `SlogBridge` probes availability once at process launch using `command -v slog_se` (after
/// sourcing `.zsh_boilerplate`) and, for each logical operation, composes a single shell script
/// that sources `.zsh_boilerplate` once then calls multiple slog functions — avoiding per-call
/// sourcing overhead.
///
/// If the boilerplate is unavailable the bridge falls back to plain `fputs`-to-stderr output.
public final class SlogBridge: @unchecked Sendable {

    // MARK: - Singleton

    public static let shared = SlogBridge()

    // MARK: - State

    /// `true` after a successful `probe()` confirmed slog availability.
    public private(set) var isAvailable = false

    /// When `true`, debug-level log calls are emitted to stderr.
    /// When `false`, they are silently dropped.
    /// Set this before calling `probe()`, typically from `SharedOptions.debug`.
    public var isDebug = false

    private let boilerplatePath = "\(ProcessInfo.processInfo.environment["HOME"] ?? "~")/.zsh_home/utilities/.zsh_boilerplate"

    // MARK: - Init

    private init() {}

    // MARK: - Probe (call once at startup)

    /// Probes whether `.zsh_boilerplate` and `slog_se` are reachable from a fresh Zsh subprocess.
    /// Uses `command -v slog_se` (which locates shell functions after sourcing boilerplate).
    /// If `slog_se` is present all `slog_*` functions are assumed to be available.
    /// Sets `isAvailable` for the duration of the process.
    public func probe() async {
        let script = #"source "\#(boilerplatePath)" 2>/dev/null && command -v slog_se > /dev/null 2>&1"#
        let result = await ZShell.execute(zsh: script)
        isAvailable = result.terminationStatus == 0
    }

    // MARK: - Logging

    /// Logs an informational message to stderr (always printed).
    public func info(_ message: String) async {
        fallbackPrint(message)
    }

    /// Logs a debug message to stderr. No-op when `isDebug` is `false`.
    public func debug(_ message: String) async {
        guard isDebug else { return }
        fallbackPrint(message)
    }

    // MARK: - Step logging

    /// Runs a complete "step" operation as a single Zsh script that sources boilerplate once.
    ///
    /// The script follows the step pattern:
    /// ```
    /// will  → execute command → success | fatal
    /// ```
    ///
    /// - Parameters:
    ///   - willMessage: Message for the `will` context (shown before execution).
    ///   - command: The shell command to execute (shown as `--code` decoration).
    ///   - successMessage: Message for the `success` context. Defaults to `willMessage`.
    ///   - onSuccess: Called with the raw stdout lines from `command` on success.
    ///   - isDryRun: When `true`, prints the command but does not execute it.
    /// - Returns: stdout lines on success, or throws on non-zero exit.
    @discardableResult
    public func runStep(
        will willMessage: String,
        command: String,
        successMessage: String? = nil,
        isDryRun: Bool = false,
        onSuccess: (([String]) -> Void)? = nil
    ) async throws -> [String] {
        let successMsg = successMessage ?? willMessage

        if isDryRun {
            if isAvailable {
                let script = [
                    preamble,
                    "slog_step_se --context will \(zshQuote(willMessage)) --default ' (dry-run, skipping)'",
                    "slog_step_se --context info 'would run: ' --code \(zshQuote(command)) --default",
                ].joined(separator: "\n")
                await ZShell.execute(zsh: script)
            } else {
                fallbackPrint("[dry-run] \(willMessage) -- would run: \(command)")
            }
            return []
        }

        let script: String
        if isAvailable {
            var lines = [preamble]
            if isDebug {
                lines.append("slog_step_se --context will 'running: ' --code \(zshQuote(command)) --default")
            }
            lines += [
                command,
                "__rval=$?",
                "if [[ $__rval -ne 0 ]]; then",
                "  slog_step_se --context fatal --exit-code \"$__rval\" \(zshQuote(willMessage))",
                "  exit $__rval",
                "fi",
            ]
            if isDebug {
                lines.append("slog_step_se --context success \(zshQuote(successMsg))")
            }
            script = lines.joined(separator: "\n")
        } else {
            if isDebug { fallbackPrint("[will] \(willMessage)") }
            script = command
        }

        let result = await ZShell.execute(zsh: script)
        if result.terminationStatus != 0 {
            if !isAvailable {
                fallbackPrint("[fatal] \(willMessage) (exit \(result.terminationStatus))")
            }
            throw SlogBridgeError.commandFailed(
                command: command,
                exitCode: result.terminationStatus,
                stderr: nil
            )
        }

        if !isAvailable, isDebug {
            fallbackPrint("[success] \(successMsg)")
        }

        let lines = (result.stdout ?? "")
            .components(separatedBy: "\n")
            .filter { !$0.isEmpty }

        onSuccess?(lines)
        return lines
    }

    // MARK: - Private helpers

    private var preamble: String {
        #"source "\#(boilerplatePath)" 2>/dev/null"#
    }

    private func fallbackPrint(_ message: String) {
        fputs("zbterms: \(message)\n", stderr)
    }

    /// Quotes `value` for safe use as a Zsh argument using ANSI-C `$'...'` syntax.
    /// Only `\` and `'` need escaping inside `$'...'`.
    private func zshQuote(_ value: String) -> String {
        let escaped = value
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "'", with: "\\'")
        return "$'\(escaped)'"
    }
}

// MARK: - ZShell convenience extension

extension ZShell {
    /// Runs a multi-line Zsh script via `/bin/zsh -c`.
    ///
    /// Stdout is captured and returned to the caller (e.g., for parsing `find` output).
    /// Stderr is connected directly to the parent process's stderr file handle so that
    /// `slog_*` output reaches the user's terminal with correct TTY detection and ANSI
    /// color support. Routing stderr through a Pipe would cause `isatty(2)` to return 0
    /// inside the subprocess, which suppresses slog's color output.
    @discardableResult
    static func execute(
        zsh script: String
    ) async -> (stdout: String?, terminationStatus: Int) {
        await withCheckedContinuation { continuation in
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/bin/zsh")
            process.arguments = ["-c", script]
            process.environment = ProcessInfo.processInfo.environment

            // Capture stdout so callers can parse results (e.g., file paths from find).
            let stdoutPipe = Pipe()
            process.standardOutput = stdoutPipe

            // Mirror stderr directly to our own stderr — no Pipe, no buffering.
            // This lets slog_* detect the terminal and emit ANSI-colored output.
            process.standardError = FileHandle.standardError

            // Stream stdout continuously to avoid pipe-buffer deadlock on large find output.
            // stdoutData is accessed only from the serial readabilityHandler queue and then
            // from terminationHandler after readGroup.wait() drains the handler — safe despite
            // the cross-closure capture that Swift's Sendable checker flags.
            nonisolated(unsafe) var stdoutData = Data()
            let readGroup = DispatchGroup()
            readGroup.enter()
            stdoutPipe.fileHandleForReading.readabilityHandler = { fh in
                let chunk = fh.availableData
                if chunk.isEmpty {
                    stdoutPipe.fileHandleForReading.readabilityHandler = nil
                    readGroup.leave()
                } else {
                    stdoutData.append(chunk)
                }
            }

            process.terminationHandler = { p in
                readGroup.wait()
                let stdout = stdoutData.isEmpty ? nil : String(data: stdoutData, encoding: .utf8)
                continuation.resume(returning: (stdout, Int(p.terminationStatus)))
            }

            do {
                try process.run()
            } catch {
                continuation.resume(returning: (nil, 127))
            }
        }
    }
}

// MARK: - Errors

public enum SlogBridgeError: Error, LocalizedError {
    case commandFailed(command: String, exitCode: Int, stderr: String?)

    public var errorDescription: String? {
        switch self {
        case let .commandFailed(command, exitCode, stderr):
            var msg = "Command failed (exit \(exitCode)): \(command)"
            if let stderr, !stderr.isEmpty {
                msg += "\nstderr: \(stderr)"
            }
            return msg
        }
    }
}
