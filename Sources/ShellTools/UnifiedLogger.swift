//
//  UnifiedLogger.swift
//
//  Created by Zakk Hoyt on 7/11/23.
//

import os.log

// swiftlint:disable prefixed_toplevel_constant
let logger = os.Logger(
    subsystem: "co.vaporwarewolf",
    category: "ShellTools"
)
// swiftlint:enable prefixed_toplevel_constant

/// Logs to both os.logger and stdout (w/color for each log level)
func log(
    _ level: OSLogType = .debug,
    _ message: String,
    _ file: StaticString = #file,
    _ function: StaticString = #function,
    _ line: Int = #line
) {
    let location = "\(#file):\(String(#line)) - \(#function)"
    let formatted = "\(location) - \(message)"
    
    let ansiItems: [ANSI.Item] = switch level {
    case .debug: [ANSI.Item(.yellowForeground)]
    default: []
    }
    let colored = "\(ANSI.UI.decorate(text: formatted, items: ansiItems))\(location) - \(message)"

    FileDescriptor.stdlog.write(colored)
    logger.log(level: level, "\(formatted)")
}
