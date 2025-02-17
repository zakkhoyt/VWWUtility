//
//  FixedWidthInteger+String.swift
//
//
//  Created by Zakk Hoyt on 1/28/24.
//

import Foundation

extension FixedWidthInteger {
    /// Creates Int type from a `hexString` (if possible)
    ///
    /// ## Example
    ///
    /// ```swift
    /// UInt8(hexString: "0x80")! == 128
    /// ```
    public init?(hexString: String) {
        self.init(
            hexString.replacingOccurrences(
                of: Radix.hexadecimal.prefix,
                with: ""
            ),
            radix: Radix.hexadecimal.value
        )
    }
    
    /// Creates Int type from a `decimalString` (if possible)
    ///
    /// ## Example
    ///
    /// ```swift
    /// UInt8(decimalString: "128")! == 128
    /// ```
    public init?(decimalString: String) {
        self.init(decimalString, radix: 10)
    }
    
    /// Creates Int type from a `binaryString` (if possible)
    ///
    /// ## Example
    ///
    /// ```swift
    /// UInt8(binaryString: "0b10000000")! == 128
    /// ```
    public init?(binaryString: String) {
        self.init(
            binaryString.replacingOccurrences(
                of: Radix.binary.prefix,
                with: ""
            ),
            radix: 2
        )
    }
}

extension FixedWidthInteger {
    /// The number of bytes in the current binary representation of `Self`.
    public static var byteWidth: Int {
        (bitWidth + Int(signBitWidth)) / 8
    }
    
    /// The number of bytes in the current binary representation of `self`
    public var byteWidth: Int {
        Self.byteWidth
    }
    
    /// The number of bits that are used to indicate negative values
    public static var signBitWidth: any FixedWidthInteger {
        isSigned ? 1 : 0
    }
    
    /// The number of bits that max unsigned value occupy (bitWidth - signBitWidth)
    public static var unsignedBitWidth: any FixedWidthInteger {
        bitWidth - Int(signBitWidth)
    }
}

extension String {
    /// Convenience for string building where input are integers.
    public init?(ifNotNil value: (any FixedWidthInteger)?) {
        guard let value else { return nil }
        self = "\(value)"
    }
}

extension FixedWidthInteger {
    public var string: String? {
        String(ifNotNil: self)
    }
}
