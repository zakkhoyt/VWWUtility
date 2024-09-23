//
// Logger.swift
//
// Created by Zakk Hoyt on 7/13/23.
//

import os

let logger = Logger(
    subsystem: "com.vaporwarewolf",
    category: "BaseUtility"
)

enum LogHelper {
    static func callerData(
        file: StaticString = #file,
        fileID: StaticString = #fileID,
        filePath: StaticString = #filePath,
        function: StaticString = #function,
        line: UInt = #line
    ) -> String {
        [
            "file: \(file)",
            "fileID: \(fileID)",
            "filePath: \(filePath)",
            "function: \(function)",
            "line: \(line)"
        ].joined(separator: "\n")
    }
}
