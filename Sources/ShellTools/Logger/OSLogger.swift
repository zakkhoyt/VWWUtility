//
//  OSLogger.swift
//  A logger which wraps the class os.Logger.
//
//  Created by Zakk Hoyt on 10/7/21.
//

#if os(macOS)

import Foundation
import os

open class OSLogger: Logger {
    // MARK: Private vars
    
    private let logger: os.Logger
    
    // MARK: Public inits
    
    public init(
        subsystem: String,
        category: String
    ) {
        self.logger = os.Logger(
            subsystem: subsystem,
            category: category
        )
    }
    
    // MARK: Public functions
    
    open func formattedLog(
        level: LogLevel = .info,
        category: String? = nil,
        message: String? = nil,
        file: StaticString = #file,
        line: Int = #line,
        function: StaticString = #function
    ) {
        let logMessage = [
            "[-\(level.rawValue)-]",
            {
                guard let category else { return nil }
                return "[-\(category)-]"
            }(),
            "[\(file):\(line)]",
            "\(function)",
            message
        ]
            .compactMap { $0 }
            .joined(separator: " ")
        
        let osLogType: OSLogType = switch level {
        case .info: .default
        case .debug: .debug
        case .warning: .debug
        case .error: .error
        case .critical: .fault
        }

        logger.log(level: osLogType, "\(logMessage)")
    }
    
    public func print(
        _ message: String? = nil
    ) {
        logger.log("\(message ?? "")")
    }
}

#endif
