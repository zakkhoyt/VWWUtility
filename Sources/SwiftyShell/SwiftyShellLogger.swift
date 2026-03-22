//
//  SwiftyShellLogger.swift
//
//  Created for SwiftyShell
//

#if os(macOS)

import os.log

// swiftlint:disable prefixed_toplevel_constant
let logger = os.Logger(
    subsystem: "SwiftyShell",
    category: "Shell"
)
// swiftlint:enable prefixed_toplevel_constant

#endif
