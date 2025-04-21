//
//  Array+MultilineListDescription.swift
//
//  Created by Zakk Hoyt on 6/23/23.
//

import Foundation

public extension Array where Element: Any, Element: Hashable {
    func multilineListDescription(
        startOnNewline: Bool = false,
        indentLevel: Int = 0,
        elementSeparator: String = ",",
        lineSeparator: String = "\n",
        endcaps: (String, String) = ("[", "]"),
        includeIndexes: Bool = false
    ) -> String {
        let outdent = String(repeating: "    ", count: indentLevel)
        let indent = String(repeating: "    ", count: indentLevel + 1)
        let endcapIndent0 = startOnNewline ? ["\n", outdent].joined() : ""
        let valueIndent = indent
        let endcapIndent1 = outdent

        let insert = lineSeparator == "\n" ? "\n" : ""
        return [
            [endcapIndent0, endcaps.0].joined(),
            insert,
            enumerated().map {
                let element = $0.element
                let i = $0.offset
                return [
                    valueIndent,
                    includeIndexes ? "[\(i)]: " : "",
                    MultilineListDescription.describe(value: element, indentLevel: indentLevel),
                    elementSeparator
                ].joined()
            }.joined(separator: lineSeparator),
            insert,
            endcapIndent1,
            endcaps.1
        ].joined()
    }
}
