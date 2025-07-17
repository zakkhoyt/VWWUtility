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
    ///         endcaps: ("", "")
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
    /// - Parameters:
    ///   `String.nil`. If `false` they will be omitted.
    ///   - separator: The `String` to use as a separator. Defaults to `", "`.
    ///   - endcaps: Two `String` to surround the joined `Element`s in. Default: `("[", "]")`
    /// - Returns: A legible `String` description of `self`
    public func listDescription(
        separator: String = ", ",
        endcaps: (Character, Character) = ("[", "]")
    ) -> String {
        let insert = separator == "\n" ? "\n" : ""
        return "\(endcaps.0)\(insert)\(map { $0.description }.joined(separator: separator))\(insert)\(endcaps.1)"
    }
}

//extension [(any CustomStringConvertible)?] {
//    /// Tranlastes `nil` values before forwarcing to `[any CustomStringConvertible].listDescription(separator:endcaps:)`
//    /// - Parameters:
//    ///   - includeNilValues: If `true`, then `nil` elements will be replaced with
//    ///   `String.nil`. If `false` they will be omitted.
//    ///   - separator: The `String` to use as a separator. Defaults to `", "`.
//    ///   - endcaps: Two `String` to surround the joined `Element`s in. Default: `("[", "]")`
//    /// - Returns: A legible `String` description of `self`
//    public func listDescription(
//        includeNilValues: Bool = true,
//        separator: String = ", ",
//        endcaps: (Character, Character) = ("[", "]")
//    ) -> String {
//        compactMap {
//            guard let element = $0 else {
//                return includeNilValues ? String.nil : nil
//            }
//            return element
//        }
//        .listDescription(separator: separator, endcaps: endcaps)
//    }
//}

extension [String: any CustomStringConvertible] {
    /// Converts any `[String: any CustomStringConvertible]` to a list by joining all `Key` & `Value` to `[String]`
    /// then joining that array and finally wrapping in encaps.
    ///
    /// - Parameters:
    ///   `String.nil`. If `false` that key/value pair will be omitted.
    ///   - separator: The `String` to use as a separator. Defaults to `", "`.
    ///   - endcaps: Two `String` to surround the joined `Element`s in. Default: `("[", "]")`
    /// - Returns: A legible `String` description of `self`
    /// - SeeAlso: `[String: (any CustomStringConvertible)?].listDescription(separator:endcaps:)`
    /// is a variant that handles optionals automatically
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

extension [String: (any CustomStringConvertible)?] {
    /// - Parameters:
    ///   - includeNilValues: If `true`, then `nil` values will be replaced with
    ///   `String.nil`. If `false` that key/value pair will be omitted.
    ///   - separator: The `String` to use as a separator. Defaults to `", "`.
    ///   - endcaps: Two `String` to surround the joined `Element`s in. Default: `("[", "]")`
    /// - Returns: A legible `String` description of `self`
    /// - SeeAlso: `[String: any CustomStringConvertible].listDescription(separator:endcaps:)`
    /// is a variant for non-optional values
    public func listDescription(
        includeNilValues: Bool = true,
        keyValueSeparator: String = ": ",
        separator: String = ", ",
        endcaps: (Character, Character) = ("[", "]")
    ) -> String {
        compactMapValues {
            guard let value = $0 else {
                return includeNilValues ? String.nil : nil
            }
            return value
        }
        .listDescription(separator: separator, endcaps: endcaps)
    }
}
