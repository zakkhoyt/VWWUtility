//
//  Dictionary+MultilineListDescription.swift
//
//  Created by Zakk Hoyt on 6/23/23.
//

import Foundation

public extension Dictionary where Key == String, Value: Hashable {
    /// Converts any `[String: Any]` to a multiline list by joining all `Key` & `Value` to `[String]`
    /// then joining that array and finally wrapping in encaps.
    /// - Parameters:
    ///   - indentLevel: Indents the whole list appropriately.
    ///   - keyValueSeparator: Separator used between keys and values. Defaults to `": "`
    ///   - keyValuePairSeparator: Separator used between key/value pairs. Defaults to `","`
    ///   - lineSeparator: Separator used between keys/value pairs
    ///   - endcaps: The endcaps to enclose all key/value pairs in. Defaults to `("[", "]")`
    /// - Returns: description
    func multilineListDescription(
        startOnNewline: Bool = false,
        indentLevel: Int = 0,
        keyValueSeparator: String = ": ",
        keyValuePairSeparator: String = ",",
        lineSeparator: String = "\n",
        endcaps: (String, String) = ("[", "]"),
        includeIndexes: Bool = false
    ) -> String {
        let baseIndent = "    "
        let outdent = String(repeating: baseIndent, count: indentLevel)
        let indent = String(repeating: baseIndent, count: indentLevel + 1)
        let endcapIndent0 = startOnNewline ? ["\n", outdent].joined() : ""
        let valueIndent = indent
        let endcapIndent1 = outdent

        return [
            ["\(endcapIndent0)\(endcaps.0)"],
            keys.sorted().enumerated().compactMap {
                let key = $0.element
                let i = $0.offset
                return [
                    valueIndent,
                    includeIndexes ? "[\(i)]: " : "",
                    key,
                    keyValueSeparator,
                    MultilineListDescription.describe(value: self[key], indentLevel: indentLevel),
                    keyValuePairSeparator
                ].joined()
            },
            ["\(endcapIndent1)\(endcaps.1)"]
        ]
        .flatMap { $0 }
        .joined(separator: lineSeparator)
    }
}

extension String {
    var quoted: String {
        #""\#(self)""#
    }
}

enum MultilineListDescription {
    // static func describe<T>(value: T) -> String where T == AnyHashable {
    static func describe<T: Hashable>(
        value: T,
        indentLevel: Int
    ) -> String {
        #warning(
            """
            TODO: zakkhoyt - Check if value is array or dict, then call .multilineListDescription
            """
        )

        let valueDescription: String
        if type(of: value) is String, let valueString = value as? String {
            valueDescription = valueString.quoted
        } else if let valueString = value as? [T] {
            valueDescription = valueString.multilineListDescription(indentLevel: indentLevel + 1)
        } else if let valueString = value as? [String: T] {
            valueDescription = valueString.multilineListDescription(indentLevel: indentLevel + 1)
        } else if let valueString = value as? any CustomStringConvertible {
            valueDescription = valueString.description.quoted
        } else if let valueString = value as? any CustomDebugStringConvertible {
            valueDescription = valueString.debugDescription.quoted
        } else {
            valueDescription = String(describing: value)
        }
        return valueDescription
    }
}
