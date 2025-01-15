//
//  CodingKey+Helpers.swift
//
//  Created by Zakk Hoyt on 2025-01-06.
//  Copyright hatch.co, 2025.
//

extension [CodingKey] {
    /// Represents an array of `[CodingKey]` as a dot delimited `String`.
    /// I.E. "current.state.desired.current"
    public var absoluteCodingPath: String {
        map { $0.stringValue }.joined(separator: ".")
    }
}
