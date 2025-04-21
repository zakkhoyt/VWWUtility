//
//  StringArray+ListDescription.swift
//
//  Created by Zakk Hoyt on 6/23/23.
//

import Foundation

extension [String] {
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
    /// // MARK: down table style:
    /// print(
    ///     array.listDescription(
    ///         separator: "|",
    ///         endcaps: ("|", "|")
    ///     )
    /// )
    /// // |a|b|c|
    /// ```
    func listDescription(
        separator: String = ", ",
        endcaps: (String, String) = ("[", "]")
    ) -> String {
        let insert = separator == "\n" ? "\n" : ""
        return "\(endcaps.0)\(insert)\(joined(separator: separator))\(insert)\(endcaps.1)"
    }

    /// Converts any `[String]` to a comma delimited list (`String` ).
    ///
    /// **SeeAlso:**
    ///
    /// `listDescription(separator:endcaps:)`
    ///
    var listDescription: String {
        listDescription()
    }
}
