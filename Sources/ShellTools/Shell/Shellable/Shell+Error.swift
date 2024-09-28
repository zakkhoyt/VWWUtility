//
//  Shell+Error.swift
//
//
//  Created by Zakk Hoyt on 6/14/24.
//

#if os(macOS)

import BaseUtility
import Foundation.NSTask

extension Shell {
    public struct Error: LocalizedError {
        public enum Cause: CustomStringConvertible {
            case processRun(any Swift.Error)
            case failedToDecodePipe(Data?)
            case nonZeroTerminationStatus(Int32)
            
            #warning("TODO: zakkhoyt - verboseError ")
            public var description: String {
                switch self {
                case .processRun(let error):
                    "Process run error: \(error.localizedDescription)"
                case .failedToDecodePipe(let data):
                    "Failed to decode pipe data: \(data?.hexString ?? "")"
                case .nonZeroTerminationStatus(let statusCode):
                    "Terminaion status: \(statusCode)"
                }
            }
        }
        
        public let command: Command
        public let response: Response
        public let cause: Cause
        
        // MARK: Implements LocalizedError
        
        public var errorDescription: String? {
            [
                "instruction": command.instruction,
                "cause": cause.description,
                "terminationStatus": "\(response.process.terminationStatus)",
                "stdout": response.stdout,
                "stderr": response.stderr
            ]
                .compactMapValues { $0 }
                .listDescription(separator: "\n\t")
        }
        
        public var failureReason: String? {
            cause.description
        }
    }
}

#endif
