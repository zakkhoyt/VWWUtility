//
//  Shell+Response.swift
//
//
//  Created by Zakk Hoyt on 6/14/24.
//

#if os(macOS)

import Foundation.NSTask

extension Shell {
    public struct Response {
        public let process: Process
        public let stdinPipe: Pipe?
        public let stdout: String?
        public let stderr: String?
        
        public init(
            process: Process,
            stdinPipe: Pipe?,
            stdout: String? = nil,
            stderr: String? = nil
        ) {
            self.process = process
            self.stdinPipe = stdinPipe
            self.stdout = stdout
            self.stderr = stderr
        }
    }
}

#endif
