//
//  STDLogger.swift
//  A logger which writes to stdout, stderr.
//
//  Created by Zakk Hoyt on 10/7/21.
//

#if os(macOS)
import Darwin
import Foundation

open class STDLogger: Logger {
    // MARK: Public vars
    
    public let subsystem: String
    public let appName: String
    
    // MARK: Private vars
    
    private let formatter = ISO8601DateFormatter()
    
    // MARK: Public inits
    
    public init(
        subsystem: String,
        appName: String
    ) {
        self.subsystem = subsystem
        self.appName = appName
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
        let dateString = formatter.string(from: Date())
        let logMessage = [
            dateString,
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
        
        let dest: UnsafeMutablePointer<FILE> = switch level {
        case .info,
             .debug,
             .warning:
            Darwin.stdout
        case .error,
             .critical:
            Darwin.stderr
        }
        fputs("\(logMessage)\n", dest)
    }

    public func print(
        _ message: String? = nil
    ) {
        fputs("\(message ?? "")\n", Darwin.stdout)
    }
}
#endif
