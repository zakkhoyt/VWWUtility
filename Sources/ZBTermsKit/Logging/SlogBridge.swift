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
        if isAvailable {
            await ZShell.execute(zsh: "\(preamble)\nslog_se \(zshQuote(message))")
        } else {
            fallbackPrint(message)
        }
    }

    /// Logs a debug message to stderr. No-op when `isDebug` is `false`.
    public func debug(_ message: String) async {
        guard isDebug else { return }
        if isAvailable {
            await ZShell.execute(zsh: "\(preamble)\nslog_se \(zshQuote(message))")
        } else {
            fallbackPrint(message)
        }
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
                stderr: result.stderr
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
    /// Runs a multi-line Zsh script via `/bin/zsh -c` and forwards subprocess stderr
    /// (where slog_* writes) to the parent's stderr file handle.
    @discardableResult
    static func execute(
        zsh script: String
    ) async -> (stdout: String?, stderr: String?, terminationStatus: Int) {
        let command = Shell.Command(
            executableURL: URL(fileURLWithPath: "/bin/zsh"),
            arguments: ["-c", script]
        )
        do {
            let response = try await ZShell.process(command: command)
            forwardStderr(response.stderr)
            return (
                stdout: response.stdout,
                stderr: response.stderr,
                terminationStatus: Int(response.process.terminationStatus)
            )
        } catch let error as Shell.Error {
            forwardStderr(error.response.stderr)
            return (
                stdout: nil,
                stderr: error.response.stderr,
                terminationStatus: Int(error.response.process.terminationStatus)
            )
        } catch {
            return (nil, error.localizedDescription, 127)
        }
    }

    private static func forwardStderr(_ stderr: String?) {
        guard let text = stderr, !text.isEmpty,
              let data = text.data(using: .utf8) else { return }
        FileHandle.standardError.write(data)
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
