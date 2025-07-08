//
//  Dictionary+ListDescription.swift
//
//  Created by Zakk Hoyt on 6/23/23.
//

import Foundation

extension [String: any CustomStringConvertible] {
    #warning("""
    FIXME: zakkhoyt - The funcftion below doesn' include endcaps
    """)
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
        endcaps _: (Character, Character) = ("[", "]")
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
        keyValueSeparator _: String = ": ",
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
