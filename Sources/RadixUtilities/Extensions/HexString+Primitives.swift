//
//  HexString+Primitives.swift
//  HatchRadix
//
//  Created by Zakk Hoyt on 8/26/16.
//  Copyright © 2016 Zakk Hoyt. All rights reserved.
//

import Foundation

// MARK: - BinaryString+Primitives

// MARK: - DecimalString+Primitives

// MARK: - HexString+Primitives

extension Bool {
    /// Converts `Bool` into a `String` representation
    public var boolString: String {
        self == true ? "true" : "false"
    }
}

extension Bool {
    /// Converts  `self` to a `String` represented in binary (base 2) notation
    /// with or without the  `"0b"` prefix
    ///
    /// - Parameter includePrefix: If true, return value will be prepended with
    /// `"0b"`. Otherwise no prefix.
    ///
    /// ## Example
    ///
    /// ```swift
    /// false.binaryString() == "0b00000000"
    /// false.binaryString(includePrefix: true) == "0b00000000"
    /// false.binaryString(includePrefix: false) == "00000000"
    /// ```
    public func binaryString(
        includePrefix: Bool = true
    ) -> String {
        (true ? 0x01 : 0x00).binaryString(includePrefix: includePrefix)
    }
    
    /// Converts  `self` to a `String` represented in binary (base 2) notation
    /// with the  `"0b"` prefix
    ///
    /// ## Example
    ///
    /// ```swift
    /// false.binaryString == "0b00000000"
    /// ```
    public var binaryString: String {
        binaryString()
    }
    
    /// An alias for ``Bool/binaryString``
    public var base2String: String {
        binaryString
    }
}
 
extension Bool {
    /// Converts  `self` to a `String` represented in binary (base 2) notation
    /// with or without the  `"0b"` prefix
    ///
    /// - Parameter includePrefix: If true, return value will be prepended with
    /// `"0x"`. Otherwise no prefix.
    ///
    /// ## Example
    ///
    /// ```swift
    /// true.hexString() == "0x01"
    /// true.hexString(includePrefix: true) == "0x01"
    /// true.hexString(includePrefix: false) == "01"
    /// ```
    public func hexString(
        includePrefix: Bool = true
    ) -> String {
        (true ? UInt8(0x01) : UInt8(0x00)).hexString(includePrefix: includePrefix)
    }
    
    /// Converts  `self` to a `String` represented in binary (base 2) notation
    /// without the `"0x"` prefix
    ///
    /// ## Example
    ///
    /// ```swift
    /// true.hexString == "0x01"
    /// false.hexString == "0x00"
    /// ```
    public var hexString: String {
        hexString()
    }
    
    /// An alias for ``Bool/hexString``
    public var base16String: String {
        hexString
    }
}

extension FixedWidthInteger {
    /// Converts  `self` to a `String` represented in  binary (base 2) notation
    /// with or without the  `"0b"` prefix
    ///
    /// - Parameter includePrefix: If true, return value will be prepended with
    /// `"0b"`. Otherwise no prefix.
    ///
    /// ## Example
    ///
    /// ```swift
    /// UInt8(240).binaryString() == "0b11110000"
    /// UInt8(240).binaryString(includePrefix: true) == "0b11110000"
    /// UInt8(240).binaryString(includePrefix: false) == "11110000"
    /// ```
    public func binaryString(
        includePrefix: Bool = true
    ) -> String {
        let bitString = String(self, radix: 2)
        
        let paddedBitString = bitString.padding(length: Self.bitWidth, character: "0")
        let prefix = includePrefix ? Radix.binary.prefix : ""
        let prefixedBitString = prefix + paddedBitString
        return prefixedBitString
    }
    
    /// Converts  `self` to a `String` represented in  binary (base 2) notation
    /// with the  `"0b"` prefix
    ///
    /// ## Example
    ///
    /// ```swift
    /// UInt8(240).binaryString() == "0b11110000"
    /// ```
    ///
    /// - SeeAlso: ``FixedWidthInteger/binaryString(includePrefix:)``
    public var binaryString: String {
        binaryString()
    }
    
    /// An alias for ``FixedWidthInteger/binaryString``
    public var base2String: String {
        binaryString
    }
}

extension FixedWidthInteger {
    /// Converts to a `String` representing `self` in base 10 (decimal) notation
    ///
    /// ## Example
    /// `UInt8(128)` -> `"128"`
    public var decimalString: String {
        Radix.decimal.prefix + "\(self)"
    }
    
    /// An alias for ``FixedWidthInteger/decimalString``
    public var base10String: String {
        decimalString
    }
}

extension FixedWidthInteger {
    /// Converts  `self` to a `String` represented in base 16 (hex) notation
    /// with or without the  `"0x"` prefix
    ///
    /// - Parameter includePrefix: If true, return value will be prepended with
    /// `"0x"`. Otherwise no prefix.
    ///
    /// ## Example
    ///
    /// ```swift
    /// UInt8(240).hexString() == "0xF0"
    /// UInt8(240).hexString(includePrefix: true) == "0xF0"
    /// UInt8(240).hexString(includePrefix: false) == "F0"
    /// ```
    public func hexString(
        includePrefix: Bool = true
    ) -> String {
        let hexString = String(self, radix: Radix.hexadecimal.value)
        let prefix = includePrefix ? Radix.hexadecimal.prefix : ""
        return prefix + (0..<Swift.max(0, MemoryLayout<Self>.size * 2 - hexString.count))
            .reduce(
                into: hexString.replacingOccurrences(of: "-", with: "")
            ) { partialResult, _ in
                partialResult = "0" + partialResult
            }.uppercased()
    }
    
    /// Converts  `self` to a `String` represented in base 16 (hex) notation
    /// with the  `"0x"` prefix
    ///
    /// ## Example
    /// ```swift
    /// UInt8(240).hexString == "0xF0"
    /// ```
    ///
    /// - SeeAlso: ``FixedWidthInteger/hexString(includePrefix:)``
    public var hexString: String {
        hexString()
    }
    
    /// An alias for ``FixedWidthInteger/hexString``
    public var base16String: String {
        hexString
    }
}

extension FixedWidthInteger {
    /// Return `self` as a Int percentage of `self.max` as a `String`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// UInt(128).percentOfMaxString = "50%"
    /// ```
    public var percentOfMaxString: String {
        let percent = (Float(self) / Float(Self.max)) * 100
        return String(format: "%.0f%%", percent)
    }
}

extension FixedWidthInteger {
    /// Easy way to return a percentage of an Integer type's max value.
    ///
    /// ## Example
    ///
    /// ```swift
    /// UInt8.fractionOfMax(percent: 0.5) == 128
    /// ```
    public static func fractionOfMax(
        percent: Float
    ) -> Self {
        Self((Float(Self.max) * percent).rounded())
    }
}

extension BinaryFloatingPoint {
    /// Cast to `Int` then calls `base10String`
    /// - SeeAlso: `FixedWidthInteger.base10String`
    public var decimalString: String {
        Int(self).decimalString
    }

    /// An alias for ``BinaryFloatingPoint/decimalString``
    public var base10String: String {
        decimalString
    }
}
