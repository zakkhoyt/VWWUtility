//
//  FixedWidthInteger+String.swift
//
//
//  Created by Zakk Hoyt on 1/28/24.
//

import Foundation

extension FixedWidthInteger {
    public init?(hexString: String) {
        guard hexString.hasPrefix("0x") else { return nil }
        self.init(hexString.replacingOccurrences(of: "0x", with: ""), radix: 16)
    }
}

extension FixedWidthInteger {
    public init?(binaryString: String) {
        guard binaryString.hasPrefix("0b") else { return nil }
        self.init(binaryString.replacingOccurrences(of: "0b", with: ""), radix: 2)
    }
}

extension FixedWidthInteger {
    /// The number of bytes in the current binary representation of this value.
    public static var byteWidth: Int {
        bitWidth / 8
    }
    
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
