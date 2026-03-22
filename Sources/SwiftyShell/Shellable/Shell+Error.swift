//
//  Shell+Error.swift
//
//
//  Created by Zakk Hoyt on 6/14/24.
//

import BaseUtility

#if os(macOS)

import Foundation.NSTask

extension Shell {
    public struct Error: LocalizedError {
        public enum Cause: CustomStringConvertible {
            case processRun(any Swift.Error)
            case failedToDecodePipe(Data?)
            case nonZeroTerminationStatus(Int32)
            case emptyCommandList

            public var description: String {
                switch self {
                case .processRun(let error):
                    "Process run error: \(error.localizedDescription)"
                case .failedToDecodePipe(let data):
                    "Failed to decode pipe data: \(data?.hexString ?? .nil)"
                case .nonZeroTerminationStatus(let statusCode):
                    "Termination status: \(statusCode)"
                case .emptyCommandList:
                    "Command list is empty"
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
                "stdout": response.stdout ?? .nilString,
                "stderr": response.stderr ?? .nilString,
                "command": command.fullInstruction
            ]
                .multilineListDescription()
        }

        public var failureReason: String? {
            cause.description
        }
    }
}

#endif
