//
//  TestDataPoints.swift
//
//  Created by Zakk Hoyt 2024.
//

@testable import RadixUtilities
import XCTest

enum TestDataPoints {
    static let types: [any FixedWidthInteger.Type] = {
        let types: [any FixedWidthInteger.Type] = [
            UInt8.self,
            UInt16.self,
            Int8.self,
            Int16.self,
            UInt32.self,
            Int32.self,
            UInt64.self,
            Int64.self
        ]
        if #available(iOS 18.0, *) {
            return types + [
                UInt128.self,
                Int128.self
            ]
        } else {
            return types
        }
    }()
    
    struct RadixStrings {
        let binaryString: String
        let decimalString: String
        let hexString: String
        
        init(
            base02 base02String: String,
            base10 base10String: String,
            base16 base16String: String
        ) {
            self.binaryString = base02String
            self.decimalString = base10String
            self.hexString = base16String
        }
    }
    
    // For these tests it's useful to have data on a single line, even if that line is long
    // swiftlint:disable line_length
    // swiftformat:disable wrapArguments
    // swiftformat:disable indent
    static let radixStringSets: [RadixStrings] = [
        // letters: 2 bytes: 1 bits: 8
        RadixStrings(
            base02: Radix.binary.prefix + "00000000",
            base10: Radix.decimal.prefix + "0",
            base16: Radix.hexadecimal.prefix + "00"
        ),
        // letters: 2 bytes: 1 bits: 8
        RadixStrings(
            base02: Radix.binary.prefix + "00001111",
            base10: Radix.decimal.prefix + "15",
            base16: Radix.hexadecimal.prefix + "0F"
        ),
        // letters: 2 bytes: 1 bits: 8
        RadixStrings(
            base02: Radix.binary.prefix + "11110000",
            base10: Radix.decimal.prefix + "240",
            base16: Radix.hexadecimal.prefix + "F0"
        ),
        // letters: 2 bytes: 1 bits: 8
        RadixStrings(
            base02: Radix.binary.prefix + "01111111",
            base10: Radix.decimal.prefix + "127",
            base16: Radix.hexadecimal.prefix + "7F"
        ),
        // letters: 2 bytes: 1 bits: 8
        RadixStrings(
            base02: Radix.binary.prefix + "11111111",
            base10: Radix.decimal.prefix + "255",
            base16: Radix.hexadecimal.prefix + "FF"
        ),
        // letters: 4 bytes: 2 bits: 16
        RadixStrings(
            base02: Radix.binary.prefix + "0000000000000000",
            base10: Radix.decimal.prefix + "0",
            base16: Radix.hexadecimal.prefix + "0000"
        ),
        // letters: 4 bytes: 2 bits: 16
        RadixStrings(
            base02: Radix.binary.prefix + "0000000011111111",
            base10: Radix.decimal.prefix + "255",
            base16: Radix.hexadecimal.prefix + "00FF"
        ),
        // letters: 4 bytes: 2 bits: 16
        RadixStrings(
            base02: Radix.binary.prefix + "1111111100000000",
            base10: Radix.decimal.prefix + "65280",
            base16: Radix.hexadecimal.prefix + "FF00"
        ),
        // letters: 4 bytes: 2 bits: 16
        RadixStrings(
            base02: Radix.binary.prefix + "0111111111111111",
            base10: Radix.decimal.prefix + "32767",
            base16: Radix.hexadecimal.prefix + "7FFF"
        ),
        // letters: 4 bytes: 2 bits: 16
        RadixStrings(
            base02: Radix.binary.prefix + "1111111111111111",
            base10: Radix.decimal.prefix + "65535",
            base16: Radix.hexadecimal.prefix + "FFFF"
        ),
        // letters: 8 bytes: 4 bits: 32
        RadixStrings(
            base02: Radix.binary.prefix + "00000000000000000000000000000000",
            base10: Radix.decimal.prefix + "0",
            base16: Radix.hexadecimal.prefix + "00000000"
        ),
        // letters: 8 bytes: 4 bits: 32
        RadixStrings(
            base02: Radix.binary.prefix + "00000000000000001111111111111111",
            base10: Radix.decimal.prefix + "65535",
            base16: Radix.hexadecimal.prefix + "0000FFFF"
        ),
        // letters: 8 bytes: 4 bits: 32
        RadixStrings(
            base02: Radix.binary.prefix + "11111111111111110000000000000000",
            base10: Radix.decimal.prefix + "4294901760",
            base16: Radix.hexadecimal.prefix + "FFFF0000"
        ),
        // letters: 8 bytes: 4 bits: 32
        RadixStrings(
            base02: Radix.binary.prefix + "01111111111111111111111111111111",
            base10: Radix.decimal.prefix + "2147483647",
            base16: Radix.hexadecimal.prefix + "7FFFFFFF"
        ),
        // letters: 8 bytes: 4 bits: 32
        RadixStrings(
            base02: Radix.binary.prefix + "11111111111111111111111111111111",
            base10: Radix.decimal.prefix + "4294967295",
            base16: Radix.hexadecimal.prefix + "FFFFFFFF"
        ),
        // letters: 16 bytes: 8 bits: 64
        RadixStrings(
            base02: Radix.binary.prefix + "0000000000000000000000000000000000000000000000000000000000000000",
            base10: Radix.decimal.prefix + "0",
            base16: Radix.hexadecimal.prefix + "0000000000000000"
        ),
        // letters: 16 bytes: 8 bits: 64
        RadixStrings(
            base02: Radix.binary.prefix + "0000000000000000000000000000000011111111111111111111111111111111",
            base10: Radix.decimal.prefix + "4294967295",
            base16: Radix.hexadecimal.prefix + "00000000FFFFFFFF"
        ),
        // letters: 16 bytes: 8 bits: 64
        RadixStrings(
            base02: Radix.binary.prefix + "1111111111111111111111111111111100000000000000000000000000000000",
            base10: Radix.decimal.prefix + "18446744069414584320",
            base16: Radix.hexadecimal.prefix + "FFFFFFFF00000000"
        ),
        // letters: 16 bytes: 8 bits: 64
        RadixStrings(
            base02: Radix.binary.prefix + "0111111111111111111111111111111111111111111111111111111111111111",
            base10: Radix.decimal.prefix + "9223372036854775807",
            base16: Radix.hexadecimal.prefix + "7FFFFFFFFFFFFFFF"
        ),
        // letters: 16 bytes: 8 bits: 64
        RadixStrings(
            base02: Radix.binary.prefix + "1111111111111111111111111111111111111111111111111111111111111111",
            base10: Radix.decimal.prefix + "18446744073709551615",
            base16: Radix.hexadecimal.prefix + "FFFFFFFFFFFFFFFF"
        ),
        // letters: 32 bytes: 16 bits: 128
        RadixStrings(
            base02: Radix.binary.prefix + "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
            base10: Radix.decimal.prefix + "0",
            base16: Radix.hexadecimal.prefix + "00000000000000000000000000000000"
        ),
        // letters: 32 bytes: 16 bits: 128
        RadixStrings(
            base02: Radix.binary.prefix + "00000000000000000000000000000000000000000000000000000000000000001111111111111111111111111111111111111111111111111111111111111111",
            base10: Radix.decimal.prefix + "18446744073709551615",
            base16: Radix.hexadecimal.prefix + "0000000000000000FFFFFFFFFFFFFFFF"
        ),
        // letters: 32 bytes: 16 bits: 128
        RadixStrings(
            base02: Radix.binary.prefix + "11111111111111111111111111111111111111111111111111111111111111110000000000000000000000000000000000000000000000000000000000000000",
            base10: Radix.decimal.prefix + "340282366920938463444927863358058659840",
            base16: Radix.hexadecimal.prefix + "FFFFFFFFFFFFFFFF0000000000000000"
        ),
        // letters: 32 bytes: 16 bits: 128
        RadixStrings(
            base02: Radix.binary.prefix + "01111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111",
            base10: Radix.decimal.prefix + "170141183460469231731687303715884105727",
            base16: Radix.hexadecimal.prefix + "7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"
        ),
        // letters: 32 bytes: 16 bits: 128
        RadixStrings(
            base02: Radix.binary.prefix + "11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111",
            base10: Radix.decimal.prefix + "340282366920938463463374607431768211455",
            base16: Radix.hexadecimal.prefix + "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"
        )
    ]
    // swiftformat:enable flagwrapArguments
    // swiftformat:enable indent
    // swiftlint:enable line_length
}
