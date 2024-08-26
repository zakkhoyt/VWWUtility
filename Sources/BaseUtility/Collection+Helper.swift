//
//  Collection+Helper.swift
//
//  Created by Zakk Hoyt on 6/23/23.
//

import Foundation

//#warning("FIXME: zakkhoyt - debugDescrition for [String: String]. Use a protocol?")
//public protocol ListDescribable {
//    var listDescription: String { get }
//
//    /// Converts any `[String]` to a list by joining all `Element`s using `separator`
//    ///
//    /// ```swift
//    /// print(["a", "b", "c"].listDescription())
//    /// // [a, b, c]
//    /// ```
//    ///
//    /// - Parameters:
//    ///   - separator: The `String` to use as a separator. Defaults to `", "`.
//    ///   - endcaps: Two `String` to surround the joined `Element`s in. Default: `("[", "]")`
//    ///
//    /// **Example:**
//    ///
//    /// ```swift
//    /// let array == ["a", "b", "c"]
//    ///
//    /// // Array style:
//    /// print(array.listDescription())
//    /// // [a, b, c]
//    ///
//    /// // CSV style:
//    /// print(
//    ///     array.listDescription(
//    ///         separator: ",",
//    ///         endcaps: ("", ",")
//    ///     )
//    /// )
//    /// // a,b,c,
//    ///
//    /// // Markdown table style:
//    /// print(
//    ///     array.listDescription(
//    ///         separator: "|",
//    ///         endcaps: ("|", "|")
//    ///     )
//    /// )
//    /// // |a|b|c|
//    /// ```
//    func listDescription(
//        separator: String,
//        endcaps: (Character, Character)
//    ) -> String
//}
//
//extension [String] {
//    /// Converts any `[String]` to a list by joining all `Element`s using `separator`
//    ///
//    /// ```swift
//    /// print(["a", "b", "c"].listDescription())
//    /// // [a, b, c]
//    /// ```
//    ///
//    /// - Parameters:
//    ///   - separator: The `String` to use as a separator. Defaults to `", "`.
//    ///   - endcaps: Two `String` to surround the joined `Element`s in. Default: `("[", "]")`
//    ///
//    /// **Example:**
//    ///
//    /// ```swift
//    /// let array == ["a", "b", "c"]
//    ///
//    /// // Array style:
//    /// print(array.listDescription())
//    /// // [a, b, c]
//    ///
//    /// // CSV style:
//    /// print(
//    ///     array.listDescription(
//    ///         separator: ",",
//    ///         endcaps: ("", ",")
//    ///     )
//    /// )
//    /// // a,b,c,
//    ///
//    /// // Markdown table style:
//    /// print(
//    ///     array.listDescription(
//    ///         separator: "|",
//    ///         endcaps: ("|", "|")
//    ///     )
//    /// )
//    /// // |a|b|c|
//    /// ```
////    public func listDescription(
////        separator: String = ", ",
////        endcaps: (Character, Character) = ("[", "]")
////    ) -> String {
////        let insert = separator == "\n" ? "\n" : ""
////        return "\(endcaps.0)\(insert)\(joined(separator: separator))\(insert)\(endcaps.1)"
////    }
//
//    /// Converts any `[String]` to a comma delimited list (`String` ).
//    ///
//    /// **SeeAlso:**
//    ///
//    /// `listDescription(separator:endcaps:)`
//    ///
//    public var listDescription: String {
//        listDescription()
//    }
//}
//
//extension Array where Element: CustomStringConvertible {
//    /// Converts any `[String]` to a list by joining all `Element`s using `separator`
//    ///
//    /// ```swift
//    /// print(["a", "b", "c"].listDescription())
//    /// // [a, b, c]
//    /// ```
//    ///
//    /// - Parameters:
//    ///   - separator: The `String` to use as a separator. Defaults to `", "`.
//    ///   - endcaps: Two `String` to surround the joined `Element`s in. Default: `("[", "]")`
//    ///
//    /// **Example:**
//    ///
//    /// ```swift
//    /// let array == ["a", "b", "c"]
//    ///
//    /// // Array style:
//    /// print(array.listDescription())
//    /// // [a, b, c]
//    ///
//    /// // CSV style:
//    /// print(
//    ///     array.listDescription(
//    ///         separator: ",",
//    ///         endcaps: ("", ",")
//    ///     )
//    /// )
//    /// // a,b,c,
//    ///
//    /// // Markdown table style:
//    /// print(
//    ///     array.listDescription(
//    ///         separator: "|",
//    ///         endcaps: ("|", "|")
//    ///     )
//    /// )
//    /// // |a|b|c|
//    /// ```
//    public func listDescription(
//        separator: String = ", ",
//        endcaps: (Character, Character) = ("[", "]")
//    ) -> String {
//        let insert = separator == "\n" ? "\n" : ""
//        return "\(endcaps.0)\(insert)\(map { $0.description }.joined(separator: separator))\(insert)\(endcaps.1)"
//    }
//
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
//
//
//
//extension [String: any CustomStringConvertible] {
////    public var dictDescription: String {
////        //        compactMapValues { $0 }
////        compactMapValues {
////            //guard let value = $0 else { return "<nil>" }
////            return String(describing: $0)
////        }
////        .map {
////            [
////                $0.key, $0.value
////            ].joined(separator: ": ")
////        }
////        .listDescription
////        //        .sorted()
////        //        .joined(separator: ", ")
////    }
//    
//    
//    /// Converts any `[String]` to a list by joining all `Element`s using `separator`
//    ///
//    /// ```swift
//    /// print(["a", "b", "c"].listDescription())
//    /// // [a, b, c]
//    /// ```
//    ///
//    /// - Parameters:
//    ///   - separator: The `String` to use as a separator. Defaults to `", "`.
//    ///   - endcaps: Two `String` to surround the joined `Element`s in. Default: `("[", "]")`
//    ///
//    /// **Example:**
//    ///
//    /// ```swift
//    /// let array == ["a", "b", "c"]
//    ///
//    /// // Array style:
//    /// print(array.listDescription())
//    /// // [a, b, c]
//    ///
//    /// // CSV style:
//    /// print(
//    ///     array.listDescription(
//    ///         separator: ",",
//    ///         endcaps: ("", ",")
//    ///     )
//    /// )
//    /// // a,b,c,
//    ///
//    /// // Markdown table style:
//    /// print(
//    ///     array.listDescription(
//    ///         separator: "|",
//    ///         endcaps: ("|", "|")
//    ///     )
//    /// )
//    /// // |a|b|c|
//    /// ```
//    public func listDescription(
//        separator: String = ", ",
//        endcaps: (Character, Character) = ("[", "]")
//    ) -> String {
//        //        compactMapValues { $0 }
//        compactMapValues {
//            //guard let value = $0 else { return "<nil>" }
//            return String(describing: $0)
//        }
//        .map {
//            [
//                $0.key, $0.value
//            ].joined(separator: ": ")
//        }.listDescription(separator: separator, endcaps: endcaps)
//        
//    }
//}
//
//
//
//#warning("FIXME: zakkhoyt - debugDescrition for [String: String]")
//
//extension [String: String?] {
//    public var varDescription: String {
////        compactMapValues { $0 }
//        compactMapValues {
//            guard let value = $0 else { return "<nil>" }
//            return value
//        }
//        .map {
//            [
//                $0.key, $0.value
//            ].joined(separator: ": ")
//        }
//        .sorted()
//        .joined(separator: ", ")
//    }
//}
//
////// extension [String: String?] {
//////    public var varDescription: String {
//////        OrderedDictionary<String, String>(
//////            self.compactMapValues { $0 }
//////        ).map {
//////            [
//////                $0.key, $0.value
//////            ].joined(separator: ": ")
//////        }.joined(separator: ", ")
//////    }
////// }
////
//////        let pairs: [String: String] = [
//////            "address": address,
//////            "class": String(describing: classForCoder),
//////            "identifier": peripheral.identifier.uuidString,
//////            "peripheralName": peripheral.name ?? "-",
//////            "advertisedName": advertisedName ?? "-",
//////            "state": peripheral.state.toString(),
//////            "hash": "\(hash)",
//////            "rssi": "\(rssi)"
//////        ]
//////
//////        let str: String = pairs.keys.sorted().reduce(into: "") {
//////            if let value = pairs[$1] {
//////                $0 += "\($1): \(value)"
//////            }
//////        }





// MARK: - hatch Copy below


#warning("FIXME: zakkhoyt - debugDescrition for [String: String]")

extension [String: String?] {
    public var varDescription: String {
        //        compactMapValues { $0 }
        compactMapValues {
            guard let value = $0 else { return "<nil>" }
            return value
        }
        .map {
            [
                $0.key, $0.value
            ].joined(separator: ": ")
        }
        .sorted()
        .joined(separator: ", ")
    }
}

//// extension [String: String?] {
////    public var varDescription: String {
////        OrderedDictionary<String, String>(
////            self.compactMapValues { $0 }
////        ).map {
////            [
////                $0.key, $0.value
////            ].joined(separator: ": ")
////        }.joined(separator: ", ")
////    }
//// }
//
////        let pairs: [String: String] = [
////            "address": address,
////            "class": String(describing: classForCoder),
////            "identifier": peripheral.identifier.uuidString,
////            "peripheralName": peripheral.name ?? "-",
////            "advertisedName": advertisedName ?? "-",
////            "state": peripheral.state.toString(),
////            "hash": "\(hash)",
////            "rssi": "\(rssi)"
////        ]
////
////        let str: String = pairs.keys.sorted().reduce(into: "") {
////            if let value = pairs[$1] {
////                $0 += "\($1): \(value)"
////            }
////        }



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
    /// Converts any `[String: String]` to a list by joining all `Key` & `Value` to `[String]`
    /// then callinging `.listDescription(separator:endcaps:)` on that array.
    ///
    /// - SeeAlso: `[any CustomStringConvertible].listDescription(separator:endcaps:)`
    public func listDescription(
        keyValueSeparator: String = ": ",
        separator: String = ", ",
        endcaps: (Character, Character) = ("[", "]")
    ) -> String {
        compactMapValues {
            return String(describing: $0)
        }
        .map {
            [
                $0.key, #""\#($0.value)""#
            ].joined(separator: keyValueSeparator)
        }
        .sorted()
        .joined(separator: separator)
    }
}


