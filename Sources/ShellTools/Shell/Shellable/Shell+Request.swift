//
//  Shell+Request.swift
//
//
//  Created by Zakk Hoyt on 6/14/24.
//

#if os(macOS)

import Foundation.NSTask

/// A namespace for value types
/// - SeeAlso: `Shell.Command`
/// - SeeAlso: `Shell.Response`
/// - SeeAlso: `Shell.Error`
public enum Shell {}

extension Shell {
    // TODO: Replace function bodies with this struct
    public struct Command: CustomStringConvertible, CustomDebugStringConvertible {
        public let executableURL: URL
        public let currentDirectoryURL: URL?
        public let arguments: [String]
        public let redirectToPipe: Bool
        public var stdinPipe: Pipe?
        public var instruction: String {
            arguments.joined(separator: " ")
        }
        
        /// - Parameters:
        ///   - executableURL: A `URL` to the executable file. EX: `/usr/bin/env'`
        ///   - currentDirectoryURL: Optional. A `URL` to the desired working directory. Defaults to process working directory.
        ///   - arguments: A `[String]` list of arguments to execute. EX: `["ls", "-al"]`.
        ///   - redirectToPipe: Routss output to stdout or a pipe to the next `Command`.
        ///   - stdinPipe: A `Pipe`instance representing output form a previous `Response`
        public init(
            executableURL: URL = URL(fileURLWithPath: "/usr/bin/env"),
            currentDirectoryURL: URL? = nil,
            arguments: String,
            redirectToPipe: Bool = false,
            stdinPipe: Pipe? = nil
        ) {
            self.executableURL = executableURL
            self.currentDirectoryURL = currentDirectoryURL
            self.arguments = arguments.shellArguments
            self.redirectToPipe = redirectToPipe
            self.stdinPipe = stdinPipe
        }
        
        public init(
            executableURL: URL = URL(fileURLWithPath: "/usr/bin/env"),
            currentDirectoryURL: URL? = nil,
            arguments: [String],
            redirectToPipe: Bool = false,
            stdinPipe: Pipe? = nil
        ) {
            self.executableURL = executableURL
            self.currentDirectoryURL = currentDirectoryURL
            self.arguments = arguments
            self.redirectToPipe = redirectToPipe
            self.stdinPipe = stdinPipe
        }
        
        var fullInstruction: String {
            ([executableURL.path] + arguments).joined(separator: " ")
        }
        
        public var description: String {
            [
                "fullInstruction": fullInstruction,
                "currentDirectoryURL": currentDirectoryURL?.absoluteString
            ]
                .compactMapValues { $0 }
                .listDescription(separator: "\n\t")
        }
        
        public var debugDescription: String {
            [
                "executableURL": executableURL.absoluteString,
                "currentDirectoryURL": currentDirectoryURL?.absoluteString,
                "arguments": arguments.description,
                "redirectToPipe": redirectToPipe.boolString,
                "stdinPipe": stdinPipe?.description
            ]
                .compactMapValues { $0 }
                .listDescription(separator: "\n\t")
        }
    }
}

#endif
