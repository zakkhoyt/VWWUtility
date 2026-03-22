//
//  Shellable+DefaultImplementations.swift
//  This protocol provides a way to execute shell commands in swift.
//  https://rderik.com/blog/using-swift-for-scripting/
//
//  Created by Zakk Hoyt on 8/5/21.
//

#if os(macOS)

import Combine
import Foundation

// MARK: - Workhorse Functions (not convenience wrappers)

private var subscriptions = Set<AnyCancellable>()

extension Shellable {
    /// The main shell "work" function (others wrap this one).
    ///
    /// ## Supported inputs:
    ///
    /// ## Supported outputs:
    /// * `stdout`
    /// * `stderr`
    /// * `ANSI` escape codes:
    ///
    /// - SeeAlso: ``HatchTerminalTools/FileDescriptor.swift``
    /// - SeeAlso: ``HatchTerminalTools/ANSI.swift``
    /// - SeeAlso: ``HatchTerminalTools/ANSI+Item.swift``
    /// - SeeAlso: `NSTask` renamed to `Process`
    /// - See: [Streams, Sockets, and Ports](https://developer.apple.com/documentation/foundation/streams_sockets_and_ports)
    /// Use low-level Unix features to manage input and output among files, processes, and the network. https://developer.apple.com/documentation/foundation/streams_sockets_and_ports
    ///
    public static func process(
        command: Shell.Command,
        completion: @escaping (Result<Shell.Response, Shell.Error>) -> Void
    ) throws {
        // If we crash due to memory leak, try uncommenting this:
        // defer { try? stdinPipe?.fileHandleForReading.close() }

#warning(
    """
    TODO: zakkhoyt - compare cli
    """
        )
        let process = Process()
        process.executableURL = command.executableURL
        process.environment = ProcessInfo.processInfo.environment
        process.currentDirectoryURL = command.currentDirectoryURL
        process.arguments = command.arguments
        

        if let stdinPipe = command.stdinPipe {
            process.standardInput = stdinPipe
            //            print("stdinPipe: \(stdinPipe.trimmedString)")
        }

        #warning(
            """
            TODO: zakkhoyt - store lines from stdout and stderr in timestamped arrays
            This will allow us to merge them into a single feed like a shell app does.
            """
        )
        let stdoutPipe = Pipe()
        process.standardOutput = stdoutPipe

        let stderrPipe = Pipe()
        process.standardError = stderrPipe

        var stdoutResult = ""

        let group = DispatchGroup()
        group.enter()
        stdoutPipe.fileHandleForReading.readabilityHandler = { fh in
            let data = fh.availableData
            if data.isEmpty { // EOF on the pipe
                stdoutPipe.fileHandleForReading.readabilityHandler = nil
                group.leave()
            } else {
                if let subresult = String(data: data, encoding: .utf8) {
                    stdoutResult.append(subresult)
                    logger.debug("Decoded subresult \(subresult.count))")
                } else {
                    logger.fault("Failed to decode subresult")
                }
            }
        }

        do {
            logger.debug("\(process.processIdentifier) will call process.run()")
            try process.run()
            logger.debug("\(process.processIdentifier) did call process.run()")
        } catch {
            logger.debug("\(process.processIdentifier) will pass error to completion handler. \(error.localizedDescription)")
            completion(
                .failure(
                    Shell.Error(
                        command: command,
                        response: Shell.Response(process: process, stdinPipe: command.stdinPipe),
                        cause: .processRun(error)
                    )
                )
            )
            logger.debug("\(process.processIdentifier) did pass error to completion handler. \(error.localizedDescription)")
        }

        // TODO: zakkhoyt - Docs refer to Task, not Process. Was there a mix up or rename? Task is a different thing in Swift.

        #warning("""
        FIXME: zakkhoyt - Add combine listener for didTerminateNotification: NSNotification.Name
        * Docs say that implementing terminationHandler is a better and more capable approach.
        * See docs for `Process.didTerminateNotification`
        """)
//        NotificationCenter.default.publisher(
//            for: Process.didTerminateNotification,
//            object: nil
//        )
        ////        .receive(on: DispatchQueue.main)
//        .sink { note in
//            guard let noteProcess = note.object as? Process else {
//                return
//            }
//            logger.debug(
//                    """
//                    Process.didTerminateNotification
//                    noteProcess \(noteProcess.processIdentifier) statsus:
//                    processIdentifier: \(noteProcess.processIdentifier)
//                    terminationStatus: \(noteProcess.processIdentifier)
//                    terminationReason: \(noteProcess.terminationReason.rawValue)
//                    """
//            )
//
//        }
//        .store(in: &subscriptions)

        weak var weakProcess = process
        Task {
            func checkProcessStatus() async {
                guard let weakProcess else { return }
                await Task.sleep(duration: 1.0)

                logger.debug(
                    """
                    Checking status for command: \(command)
                    \(process.processIdentifier) status:
                    processIdentifier: \(weakProcess.processIdentifier)
                    isRunning: \(weakProcess.isRunning)
                    """
                )

                if weakProcess.isRunning == true {
                    await checkProcessStatus()
                } else {}
            }

            await checkProcessStatus()
        }

        #warning("FIXME: zakkhoyt - https://forums.swift.org/t/the-problem-with-a-frozen-process-in-swift-process-class/39579/6")
//        let group = DispatchGroup()
//        group.enter()
//        stdoutPipe.fileHandleForReading.readabilityHandler = { fh in
//            let data = fh.availableData
//            if data.isEmpty { // EOF on the pipe
//                pipe.fileHandleForReading.readabilityHandler = nil
//                group.leave()
//            } else {
//                result.append(String(data: data, encoding: .utf8)!)
//            }
//        }

//        try process.run()
//        process.waitUntilExit()
//        group.wait() // Wait for EOF on the pipe.

        process.qualityOfService = .userInitiated
        process.terminationHandler = { terminatedProcess in
            let message: String = [
                "terminatedProcess": "\(terminatedProcess.processIdentifier)",
                "terminationStatus": "\(terminatedProcess.terminationStatus)",
                "terminationReason": "\(terminatedProcess.terminationReason.rawValue)"
            ].listDescription()

            if terminatedProcess.terminationStatus == 0 {
                logger.debug(
                    """
                    Process \(process.processIdentifier) terminated successfully.
                    \(message)
                    """
                )
            } else {
                logger.fault(
                    """
                    Process \(process.processIdentifier) terminated unsuccessfully.
                    \(message)
                    """
                )
            }
            let response = Shell.Response(
                process: terminatedProcess,
                stdinPipe: command.stdinPipe,
//                stdout: command.redirectToPipe ? nil : stdoutPipe.trimmedString,
                stdout: command.redirectToPipe ? nil : stdoutResult,
                stderr: stderrPipe.trimmedString
            )

            #warning("FIXME: zakkhoyt - account for this")

            switch terminatedProcess.terminationReason {
            case .exit:
                break
            case .uncaughtSignal:
                break
            }

            //            This method raises an NSInvalidArgumentException if the receiver is still running. Verify that the receiver isn’t running before you use it.
            switch terminatedProcess.terminationStatus {
            case 0:
                completion(.success(response))
            default:
                completion(
                    .failure(
                        Shell.Error(
                            command: command,
                            response: response,
                            cause: .nonZeroTerminationStatus(terminatedProcess.terminationStatus)
                        )
                    )
                )
            }
        }
        process.waitUntilExit()

        group.wait() // Wait for EOF on the stdoutpipe.

//        logger.debug("YO DONE \(process.processIdentifier) stdoutResult: \(stdoutResult) ")
    }

    public static func process(
        command: Shell.Command
    ) async throws -> Shell.Response {
        try await withCheckedThrowingContinuation { continuation in
            do {
                try process(
                    command: command
                ) { result in
                    switch result {
                    case .success(let response):
                        continuation.resume(with: .success(response))
                    case .failure(let error):
                        continuation.resume(with: .failure(error))
                    }
                }
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}

// MARK: - wrapper functions

extension Shellable {
    /// This variant takes in an array of `[Shell.Command]` and provides closure for
    /// progress/feedback as the commands are iterated.
    /// - Parameter commands: An array of commands: `[Shell.Command]` to be iterated through
    /// in a serial manner.
    /// - Parameter progress: This closure is called after each `Shell.Command` has terminated.
    /// - Throws: `Shell.Error` is thrown if any of command in the lists throws.
    public static func process(
        commands: [Shell.Command],
        progress: @escaping (Shell.Response) -> Void
    ) async throws {
        // Retain previous response so that we can pipe commands together.
        var previousResponse: Shell.Response?
        for command in commands {
            let response = try await process(
                command: {
                    var r = command
                    r.stdinPipe = previousResponse?.process.standardOutput as? Pipe
                    return r
                }()
            )
            progress(response)
            previousResponse = response
        }
    }

    /// This variant takes in an array of `[Shell.Command]`
    /// - Parameter commands: An array of commands: `[Shell.Command]` to be iterated through
    /// in a serial manner.
    /// - Returns: The `Shell.Response` of the last command in `commands`
    /// - Throws: `Shell.Error` is thrown if any of command in the lists throws, or if commands is empty.
    public static func process(
        commands: [Shell.Command]
    ) async throws -> Shell.Response {
        guard !commands.isEmpty else {
            throw NSError(
                domain: "SwiftyShell",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Command list is empty"]
            )
        }
        
        // Retain previous response so that we can pipe commands together.
        var previousResponse: Shell.Response?
        #warning("TODO: zakkhoyt: for await arguments in argumentLists. AsyncStream")
        for command in commands {
            previousResponse = try await process(
                command: {
                    var r = command
                    r.stdinPipe = previousResponse?.process.standardOutput as? Pipe
                    return r
                }()
            )
        }

        // Safe to force unwrap since we verified commands is not empty
        return previousResponse!
    }
}

// MARK: Simplified API (String I/O)

extension Shellable {
    /// Simplified syntax using `String` types for input and output
    ///
    /// This function will not tell you much about what went wrong. If you are looking for that
    /// use one of the other functions.
    ///
    /// - Parameter command: A command string. EX: `date -Iseconds`
    /// - Returns: A `(stdout: String?, stderr: String?, terminationStatus: Int)`
    @discardableResult
    public static func execute(
        _ command: String
    ) async -> (stdout: String?, stderr: String?, terminationStatus: Int) {
        /// Converts a `Shell.Response` to a simplified `String` representation
        func tupleOutput(
            response: Shell.Response
        ) -> (stdout: String?, stderr: String?, terminationStatus: Int) {
            (
                stdout: response.stdout,
                stderr: response.stderr,
                terminationStatus: Int(response.process.terminationStatus)
            )
        }
        
        do {
            logger.debug("Executing shell command: \(command, privacy: .public)")
            let arguments = command.shellArguments
            let response = try await ZShell.process(
                command: Shell.Command(arguments: arguments)
            )
            return tupleOutput(response: response)
        } catch let error as Shell.Error {
            logger.error("Shell.Error with command: \(command) error: \(error.localizedDescription)")
            return tupleOutput(response: error.response)
        } catch {
            logger.error("\(error.localizedDescription)")
            let code = (error as NSError).code
            let terminationStatus = code == 0 ? 127 : code
            return (nil, nil, terminationStatus)
        }
    }

    /// This is like `execute(_ command: String)` but returns only stdout
    ///
    /// Simplified syntax using `String` types for input and output
    ///
    /// This function will not tell you much about what went wrong. If you are looking for that
    /// use one of the other functions.
    ///
    /// - Parameter command: A command string. EX: `date -Iseconds`
    /// - Returns: A `String?` representing stdout
    @discardableResult
    public static func run(
        _ command: String
    ) async -> String? {
        await execute(command).0
    }
}

extension Shellable {
    /// Simplified syntax using `String` types for input and output
    /// - Warning: This function will block the current thread until completion.
    /// To avoid this use a closure or async function.
    /// - Parameter arguments: A list of arguments
    /// - Returns: stdout as `String?`
    @available(*, deprecated, message: "Please adopt a newer (non-blocking) variant execute(:)")
    @discardableResult
    public static func legacyExecute(
        _ arguments: [String]
    ) -> String? {
        let process = Process()
        // To learn why we are using the `env` command here, read this article:
        // https://rderik.com/blog/using-swift-for-scripting/#our-first-swift-script
        process.launchPath = "/usr/bin/env"
        process.arguments = arguments
        process.waitUntilExit()

        let pipe = Pipe()
        process.standardOutput = pipe
        process.launch()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: .utf8)?
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension Process.TerminationReason: @retroactive CustomStringConvertible {
    public var description: String {
        switch self {
        case .exit: "exit"
        case .uncaughtSignal: "uncaughtSignal"
        @unknown default: "unknown"
        }
    }
}

extension Process.TerminationReason: @retroactive CustomDebugStringConvertible {
    public var debugDescription: String {
        "\(description) (\(rawValue))"
    }
}

extension Task where Success == Never, Failure == Never {
    /// Use this method only if the `Task` that calls it cannot be cancelled.
    /// If there's a possibility of cancellation, consider using `Task.delayed(byTimeInterval:priority:operation:)` instead.
    /// Note:
    /// If the `Task` is cancelled, `Task.sleep(nanoseconds:)` will throw an error:
    ///   1. `assertionFailure` will cause a crash in dev builds
    ///   2. Thrown errors will be silenced in prod builds
    public static func sleep(duration: TimeInterval) async {
        do {
            try await Task.sleep(nanoseconds: UInt64(duration * 1000000000))
        } catch {
            assertionFailure("Task.sleep failed with error: \(error)")
        }
    }
}
#endif
