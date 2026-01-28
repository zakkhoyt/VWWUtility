//
//  Array+ListDescription.swift
//
//  Created by Zakk Hoyt on 6/23/23.
//

import Foundation

#warning(
    """
    TODO: zakkhoyt - Make it easier to specify single line vs multiline
    * Via param? `multiline: Bool`
    * Maybe with an `indentLevel: Int` param?
    * Wrapping arrays vs not
    """
)

/// ```swift
/// let separator = "\t\n"
/// let debugMessage: String = [
///     "rootDirectoryURL": rootDirectoryURL.path(),
///     "packageSwiftURLs": "\n\t" + packageSwiftURLs.listDescription(separator: "\n\t\t", endcaps: ("[\n\t\t", "\n\t]")),
///     "ignoreSwiftPackageURLs": ignoreSwiftPackageURLs.listDescription(separator: "\n\t\t", endcaps: ("[\n\t\t", "\n\t]")),
///     "skipJsonConversion": skipJsonConversion.boolString,
///     "outputDirectoryURL": outputDirectoryURL.path,
///     "renderEngine": renderEngine.description,
///     "renderFormat": renderFormat.description,
///     "isDebug": isDebug.boolString,
///     "isDryRun": isDryRun.boolString,
/// ]
///     .listDescription(separator: separator)
/// logger.debug("\(#fileID):\(#line) - \(String(describing: type(of: self))) \(#function)\(separator)\(debugMessage)")
/// ```
///
/// ```log
/// "ignoreSwiftPackageURLs": "[
///     file:///Users/zakkhoyt/code/repositories/hatch/hatch_sleep/2/HatchDependencyGrapher/Package.swift
/// ]"
/// "isDebug": "false"
/// "isDryRun": "false"
/// "outputDirectoryURL": "/Users/zakkhoyt/code/repositories/hatch/hatch_sleep/2/SwiftDependencyGraph"
/// "renderEngine": "plantUML"
/// "renderFormat": "svg"
/// "rootDirectoryURL": "/Users/zakkhoyt/code/repositories/hatch/hatch_sleep/2"
/// "skipJsonConversion": "true"
/// "packageSwiftURLs": "
/// [
///     file:///Users/zakkhoyt/code/repositories/hatch/hatch_sleep/2/HatchLogger/Package.swift
///     file:///Users/zakkhoyt/code/repositories/hatch/hatch_sleep/2/HatchModels/Package.swift
///     file:///Users/zakkhoyt/code/repositories/hatch/hatch_sleep/2/ArgumentKit/Package.swift
/// ]"
/// ```
///

#warning(
    """
    TODO: zakkhoyt - Better support for types (not strictly [String: String]
    """
)

// public extension [any CustomStringConvertible] {
extension Array where Element: CustomStringConvertible {
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
    /// // MARK: down table style:
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
        endcaps: (String, String) = ("[", "]")
    ) -> String {
        let insert = separator == "\n" ? "\n" : ""
        return "\(endcaps.0)\(insert)\(map { $0.description }.joined(separator: separator))\(insert)\(endcaps.1)"
    }
}

extension [(any CustomStringConvertible)?] {
    /// Tranlastes `nil` values before forwarcing to `[any CustomStringConvertible].listDescription(separator:endcaps:)`
    /// - Parameters:
    ///   - includeNilValues: If `true`, then `nil` elements will be replaced with
    ///   `String.nil`. If `false` they will be omitted.
    ///   - separator: The `String` to use as a separator. Defaults to `", "`.
    ///   - endcaps: Two `String` to surround the joined `Element`s in. Default: `("[", "]")`
    /// - Returns: A legible `String` description of `self`
    public func listDescription(
        includeNilValues: Bool = true,
        separator: String = ", ",
        endcaps: (Character, Character) = ("[", "]")
    ) -> String {
        compactMap {
            guard let element = $0 else {
                return includeNilValues ? String.nil : nil
            }
            return element
        }
        .listDescription(separator: separator, endcaps: endcaps)
    }
}
//
//#warning(
//    """
//    TODO: zakkhoyt - Better support for types (not strictly [String: String]
//    * Only include quotes around values if type is String
//    """
//)
//
//extension Array where Element: CustomStringConvertible {
//    /// Converts any `[CustomStringConvertible]` to a comma delimited list (`String` ).
//    public var listDescription: String {
//        map { $0.description }.listDescription
//    }
//}
//
//extension Array where Element: CustomDebugStringConvertible {
//    /// Converts any `[CustomDebugStringConvertible]` to a comma delimited list (`String` ).
//    public var listDescription: String {
//        map { $0.debugDescription }.listDescription
//    }
//}
