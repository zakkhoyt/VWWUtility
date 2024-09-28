//
//  Shellable+DefaultImplementations.swift
//  This protocol provides a way to execute shell commands in swift.
//  https://rderik.com/blog/using-swift-for-scripting/
//
//  Created by Zakk Hoyt on 8/5/21.
//

#if os(macOS)

import Foundation

// MARK: - Workhorse Functions (not convenience wrappers)

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
    public static func process(
        command: Shell.Command,
        completion: @escaping (Result<Shell.Response, Shell.Error>) -> Void
    ) throws {
        // If we crash due to memory leak, try uncommenting this:
        // defer { try? stdinPipe?.fileHandleForReading.close() }
        
        let process = Process()
        process.executableURL = command.executableURL
        process.environment = ProcessInfo.processInfo.environment
        process.currentDirectoryURL = command.currentDirectoryURL
        process.arguments = command.arguments
        
        if let stdinPipe = command.stdinPipe {
            process.standardInput = stdinPipe
            //            print("stdinPipe: \(stdinPipe.trimmedString)")
        }
        
        let stdoutPipe = Pipe()
        process.standardOutput = stdoutPipe
        
        let stderrPipe = Pipe()
        process.standardError = stderrPipe
        
        do {
            try process.run()
        } catch {
            completion(
                .failure(
                    Shell.Error(
                        command: command,
                        response: Shell.Response(process: process, stdinPipe: command.stdinPipe),
                        cause: .processRun(error)
                    )
                )
            )
        }
        
        process.terminationHandler = { process in
            let response = Shell.Response(
                process: process,
                stdinPipe: command.stdinPipe,
                stdout: command.redirectToPipe ? nil : stdoutPipe.trimmedString,
                stderr: stderrPipe.trimmedString
            )
            
            switch process.terminationStatus {
            case 0:
                completion(.success(response))
            default:
                completion(
                    .failure(
                        Shell.Error(
                            command: command,
                            response: response,
                            cause: .nonZeroTerminationStatus(process.terminationStatus)
                        )
                    )
                )
            }
        }
        process.waitUntilExit()
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
    /// - Returns: The `Shell.Repsonse` of the last command in `commands`
    /// - Throws: `Shell.Error` is thrown if any of command in the lists throws.
    public static func process(
        commands: [Shell.Command]
    ) async throws -> Shell.Response {
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
        
        guard let previousResponse else {
            fatalError("No previous response to return")
        }
        return previousResponse
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
    
    /// Simplified syntax using `String` types for input and output
    ///
    /// This function will not tell you much about what went wrong. If you are looking for that
    /// use one of the other functions.
    ///
    /// - Parameter command: A command string. EX: `date -Iseconds`
    /// - Returns: A `String?` representing stdout
    @discardableResult
    public static func execute(
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

#endif
