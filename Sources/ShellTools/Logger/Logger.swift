//
//  Logger.swift
//  A template for concrete loggers.
//
//  Created by Zakk Hoyt on 10/7/21.
//

import Foundation

public enum LogLevel: String {
    case info = "Info"
    case debug = "Debug"
    case warning = "Warning"
    case error = "Error"
    case critical = "Critical"
}

public protocol Logger {
    func formattedLog(
        level: LogLevel,
        category: String?,
        message: String?,
        file: StaticString,
        line: Int,
        function: StaticString
    )
    
    func print(_ message: String?)
}

extension Logger {
    public func info(
        category: String? = nil,
        _ message: String? = nil,
        _ file: StaticString = #file,
        _ line: Int = #line,
        _ function: StaticString = #function
    ) {
        formattedLog(
            level: .info,
            category: category,
            message: message,
            file: file,
            line: line,
            function: function
        )
    }
    
    public func debug(
        category: String? = nil,
        _ message: String? = nil,
        _ file: StaticString = #file,
        _ line: Int = #line,
        _ function: StaticString = #function
    ) {
        formattedLog(
            level: .debug,
            category: category,
            message: message,
            file: file,
            line: line,
            function: function
        )
    }
    
    public func warning(
        category: String? = nil,
        _ message: String? = nil,
        _ file: StaticString = #file,
        _ line: Int = #line,
        _ function: StaticString = #function
    ) {
        formattedLog(
            level: .warning,
            category: category,
            message: message,
            file: file,
            line: line,
            function: function
        )
    }
    
    public func error(
        category: String? = nil,
        _ message: String? = nil,
        _ file: StaticString = #file,
        _ line: Int = #line,
        _ function: StaticString = #function
    ) {
        formattedLog(
            level: .error,
            category: category,
            message: message,
            file: file,
            line: line,
            function: function
        )
    }
    
    public func error(
        category: String? = nil,
        _ error: (any Error)? = nil,
        _ file: StaticString = #file,
        _ line: Int = #line,
        _ function: StaticString = #function
    ) {
        formattedLog(
            level: .error,
            category: category,
            message: error?.logString,
            file: file,
            line: line,
            function: function
        )
    }
    
    public func critical(
        category: String? = nil,
        _ message: String? = nil,
        _ file: StaticString = #file,
        _ line: Int = #line,
        _ function: StaticString = #function
    ) {
        formattedLog(
            level: .critical,
            category: category,
            message: message,
            file: file,
            line: line,
            function: function
        )
    }
    
    public func critical(
        category: String? = nil,
        _ error: (any Error)? = nil,
        _ file: StaticString = #file,
        _ line: Int = #line,
        _ function: StaticString = #function
    ) {
        formattedLog(
            level: .critical,
            category: category,
            message: error?.logString,
            file: file,
            line: line,
            function: function
        )
    }
}

extension Error {
    /// Returns as much error detail as possible.
    var logString: String {
        let nsError = self as NSError
        return (
            [
                nsError.localizedDescription,
                nsError.localizedFailureReason,
                nsError.localizedRecoverySuggestion
            ]
                + (nsError.localizedRecoveryOptions ?? [])
        )
        .compactMap { $0 }
        .joined(separator: "\n")
    }
}
