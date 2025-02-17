//
//  UnifiedLogger.swift
//
//  Created by main 2.2.6.
//  Copyright hatch.co, 2024.
//
//  https://www.pointfree.co/collections/dependencies
//  https://hatchbaby.slack.com/archives/C01L0U4GBBN/p1727732824388519
//

import os.log

// swiftlint:disable prefixed_toplevel_constant
let logger = os.Logger(
    subsystem: "co.hatch",
    category: "HatchRadixUtilities"
)
// swiftlint:enable prefixed_toplevel_constant
