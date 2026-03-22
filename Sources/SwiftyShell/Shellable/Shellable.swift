//
//  Shellable.swift
//  This protocol provides a way to execute shell commands in swift.
//  https://rderik.com/blog/using-swift-for-scripting/
//
//  Created by Zakk Hoyt on 8/5/21.
//

#if os(macOS)

import Foundation

public enum ShellInputError: Swift.Error {
    case stdinEmpty
    case noStdOut
    case terminationStatus(Int32)
}

#warning("FIXME: zakkhoyt - Make this into a class or static functions")

/// Contains wrapper functions for running shell commands.
/// ## Supported inputs:
///
/// ## Supported outputs:
/// * `stdout`
/// * `stderr`
/// * `ANSI` escape codes:
///
/// - SeeAlso: `Shellable+DefaultImplementations.swift`
/// - SeeAlso: `NSTask` renamed to `Process`
///
/// # References:
/// * [Streams, Sockets, and Ports (Apple)](https://developer.apple.com/documentation/foundation/streams_sockets_and_ports) - Use low-level Unix features to manage input and output among files, processes, and the network.
///     * [Process](https://developer.apple.com/documentation/foundation/process)  - A process operates within an environment defined by the current values for several items: the current directory, standard input, standard output, standard error, and the values of any environment variables. By default, a Process object inherits its environment from the process that launches it.
///     ⚠️ Important: In a sandboxed app, child processes you create with the Process class inherit the sandbox of the parent app. Instead, write helper apps as XPC Services because it allows you to specify different sandbox entitlements for helper apps. For more information, see Daemons and Services Programming Guide and XPC.
///         * `environment`: A dictionary of environment variable values whose keys are the variable names.
///             ⚠️ Important: Inherited from the process that created it, but can be overridden at `init` time.

public protocol Shellable {
    /// Executes shell command
    /// - Parameters:
    ///   - command: A `Shell.Command` representing a shell command.
    ///   - completion: A completion handler. Called after the process terminates.
    static func process(
        command: Shell.Command,
        completion: @escaping (Result<Shell.Response, Shell.Error>) -> Void
    ) throws

    /// Executes shell command
    /// - Parameters:
    ///   - command: A `Shell.Command` representing a shell command.
    /// - Returns:A `Shell.Response` instance.
    /// - Throws: `Shell.Error`
    static func process(
        command: Shell.Command
    ) async throws -> Shell.Response
}

#endif
