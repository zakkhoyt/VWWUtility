//
//  Collection+Helper.swift
//
//  Created by Zakk Hoyt on 6/23/23.
//

import Foundation

extension [any CustomStringConvertible] {
    /// Converts any `[String]` to a list by joining all `Element`s using `separator`
    ///
    /// ```swift
    /// print(["a", "b", "c"].listDescription())
    /// // [a, b, c]
    /// ```
    ///
    /// - Parameters:
    ///   - separator: The `String` to use as a separator. Defaults to `", "`.
    ///   - endcaps: Two `String` to surround the joined `Element`s in. Default: `("[", "]")`
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let array == ["a", "b", "c"]
    ///
    /// // Array style:
    /// print(array.listDescription())
    /// // [a, b, c]
    ///
    /// // CSV style:
    /// print(
    ///     array.listDescription(
    ///         separator: ",",
    ///         endcaps: ("", ",")
    ///     )
    /// )
    /// // a,b,c,
    ///
    /// // Markdown table style:
    /// print(
    ///     array.listDescription(
    ///         separator: "|",
    ///         endcaps: ("|", "|")
    ///     )
    /// )
    /// // |a|b|c|
    /// ```
    public func listDescription(
        separator: String = ", ",
        endcaps: (Character, Character) = ("[", "]")
    ) -> String {
        let insert = separator == "\n" ? "\n" : ""
        return "\(endcaps.0)\(insert)\(map { $0.description }.joined(separator: separator))\(insert)\(endcaps.1)"
    }
}

extension [String: any CustomStringConvertible] {
    /// Converts any `[String: any CustomStringConvertible]` to a list by joining all `Key` & `Value` to `[String]`
    /// then joining that array and finally wrapping in encaps.
    ///
    /// - SeeAlso: `[any CustomStringConvertible].listDescription(separator:endcaps:)`
    public func listDescription(
        keyValueSeparator: String = ": ",
        separator: String = ", ",
        endcaps: (Character, Character) = ("[", "]")
    ) -> String {
        compactMapValues { String(describing: $0) }
        .map {
            [#""\#($0.key)""#, #""\#($0.value)""#].joined(separator: keyValueSeparator)
        }
        .sorted()
        .joined(separator: separator)
    }
}









//extension [String: String?] {
//    public func listDescription(
//        //        keyValueSeparator: String = ": ",
//        //        separator: String = ", ",
//        //        endcaps: (String, String) = ("[", "]"),
//        //        level: Int = 0
//        keyValueSeparator: String = ": ",
//        //        separator: String = ", ",
//        separator: String = ",\n",
//        //        endcaps: (String, String) = ("[", "]"),
//        endcaps: (String, String) = ("[\n", "\n]"),
//        level: Int = 0
//    ) -> String {
//        (compactMapValues { $0 } as [String: String])
//            .listDescription(
//                keyValueSeparator: keyValueSeparator,
//                separator: separator,
//                endcaps: endcaps,
//                level: level
//            )
//    }
//}

//
//    //#warning("FIXME: zakkhoyt - support nested, indented lists")
//    #warning(#"""
//    FIXME: zakkhoyt - support nested, indented lists
//    """
//    [
//        "name": "abe",
//        "children": [
//            "buck": "son",
//            "casie": "daughter
//        ]
//    ]
//    """
//    """#)

//#warning("FIXME: zakkhoyt - support StringProtocol, CustomStringConvertible, etc...")
////extension [String: any StringProtocol] {
//extension [String: String] {
//    /// Converts any `[String: any CustomStringConvertible]` to a list by joining all `Key` & `Value` to `[String]`
//    /// then joining that array and finally wrapping in encaps.
//    ///
//    /// - SeeAlso: `[any CustomStringConvertible].listDescription(separator:endcaps:)`
//    public func listDescription(
//        keyValueSeparator: String = ": ",
//        //        separator: String = ", ",
//        separator: String = ",\n",
//        //        endcaps: (String, String) = ("[", "]"),
//        endcaps: (String, String) = ("[\n", "\n]"),
//        level: Int = 0
//    ) -> String {
//        //        (separator: ",\n", endcaps: ("[\n", "\n]"))
//        
//        let contentIndent = String(repeating: "    ", count: level + 1)
//        
//        let content = compactMapValues { String(describing: $0) }
//            .map {
//                [#""\#($0.key)""#, #""\#($0.value)""#].joined(separator: keyValueSeparator)
//            }
//            .sorted()
//            .map { contentIndent + $0 }
//            .joined(separator: separator)
//        
//        let globalIndent = String(repeating: "    ", count: level)
//        return [
//            endcaps.0,
//            content,
//            endcaps.1
//        ]
//            .map { globalIndent + $0 }
//            .joined()
//    }
//}
