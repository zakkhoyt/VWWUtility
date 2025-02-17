//
//  HexString+Collections.swift
//
//
//  Created by Zakk Hoyt on 7/27/23.
//

import Foundation

extension Array where Element: FixedWidthInteger {
    /// Converts all elements to a single `String` represented in base 16 (hex) notation
    /// with or without the  `"0x"` prefix
    ///
    /// - Parameter includePrefix: If true, return value will be prepended with
    /// `"0x"`. Otherwise no prefix.
    ///
    /// ## Example
    ///
    /// ```swift
    /// [UInt8(0xFF), UInt8(80)].hexString() == "0xFF80"
    /// [UInt8(0xFF), UInt8(80)].hexString(includePrefix: true) == "0xFF80"
    /// [UInt8(0xFF), UInt8(80)].hexString(includePrefix: false) == "FF80"
    /// ```
    public func hexString(
        includePrefix: Bool = true
    ) -> String {
        (includePrefix ? Radix.hexadecimal.prefix : "")
            + map { $0.hexString(includePrefix: false) }.joined()
    }
    
    /// Converts all elements to a single `String` represented in base 16 (hex) notation
    /// with the  `"0x"` prefix
    ///
    /// ## Example
    /// ```swift
    /// [UInt8(0xFF), UInt8(80)].hexString == "0xFF80"
    /// ```
    ///
    /// - SeeAlso: ``Array/hexString(includePrefix:)``
    public var hexString: String {
        hexString()
    }
}
