//
//  Logger.swift
//  ANSIUtilities
//
//  Internal logger for ANSIUtilities
//

#if os(macOS)
import os.log

// swiftlint:disable prefixed_toplevel_constant
let logger = os.Logger(
    subsystem: "co.hatch",
    category: "ANSIUtilities"
)
// swiftlint:enable prefixed_toplevel_constant

#endif
