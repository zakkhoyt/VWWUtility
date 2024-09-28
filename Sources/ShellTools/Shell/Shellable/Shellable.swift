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
///
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
