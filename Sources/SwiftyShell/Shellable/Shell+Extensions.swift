//
//  Shell+Extensions.swift
//
//
//  Created by Zakk Hoyt on 6/14/24.
//

#if os(macOS)

import Foundation

extension Process {
    public var commandLine: String {
        ([executableURL?.path] + (arguments ?? []))
            .compactMap { $0 }
            .joined(separator: " ")
    }
}

extension Pipe {
    var trimmedString: String? {
        let data = fileHandleForReading.readDataToEndOfFile()
        guard !data.isEmpty else { return nil }
        return String(data: data, encoding: String.Encoding.utf8)?
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension String {
    /// Converts a space delimeted `String` into `[String]`
    /// EX:  `"ls -al"` -> `["ls", "-al"]`
    public var shellArguments: [String] {
        split(separator: " ").map { String($0) }
    }
}

extension [String] {
    /// Converts an array of space delimeted `[String]` into `[[String]]`.
    /// EX:  `["pwd", "ls -al"]` -> `[["pwd"], ["ls", "-al"]]`
    public var shellArgumentLists: [[String]] {
        map {
            $0.shellArguments
        }
    }
}

#endif
