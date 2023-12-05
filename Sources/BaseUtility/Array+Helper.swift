//
//  Array+Helper.swift
//
//  Created by Zakk Hoyt on 6/23/23.
//

import Foundation

public struct AsyncArray<T>: AsyncSequence, AsyncIteratorProtocol {
    public typealias Element = T

    public let items: [T]
    private var index = 0
    
    public init(items: [T]) {
        self.items = items
    }

    public mutating func next() async -> T? {
        guard !Task.isCancelled else {
            return nil
        }

        guard index < items.count else {
            return nil
        }

        let result = items[index]
        index += 1
        return result
    }

    public func makeAsyncIterator() -> Self {
        self
    }
}

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
    public var listDescription: String {
        listDescription()
    }
}

extension Array where Element: CustomStringConvertible {
    public func listDescription(
        separator: String = ", ",
        endcaps: (String, String) = ("[", "]")
    ) -> String {
        let insert = separator == "\n" ? "\n" : ""
        return "\(endcaps.0)\(insert)\(map { $0.description }.joined(separator: separator))\(insert)\(endcaps.1)"
    }

    /// Converts any `[CustomStringConvertible]` to a comma delimited list (`String` ).
    public var listDescription: String {
        map { $0.description }.listDescription
    }
}

extension Array where Element: CustomDebugStringConvertible {
    /// Converts any `[CustomDebugStringConvertible]` to a comma delimited list (`String` ).
    public var listDescription: String {
        map { $0.debugDescription }.listDescription
    }
}

