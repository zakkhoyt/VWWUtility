//
//  RadixStringTests.swift
//
//  Created by Zakk Hoyt on 2024-12-04.
//  Copyright hatch.co, 2024.
//

@testable import HatchRadixUtilities
import XCTest

final class RadixStringTests: XCTestCase {
    func testPrimitiveRadixStrings() throws {
        let bitsPerByte = 8
        
        func examine<F: FixedWidthInteger>(
            f: F,
            expectedBitWidth: Int,
            expectedByteWidth: Int,
            expectedBinaryString: String,
            expectedDecimalString: String,
            expectedHexString: String,
            verbose: Bool = false
        ) {
            if verbose {
                print("---- ---- ---- ----")
                print("\(F.self).bitWidth: \(f.bitWidth)")
                print("----")
                print("MemoryLayout<\(F.self)>.size: \(MemoryLayout<F>.size * bitsPerByte)")
                print("MemoryLayout<\(F.self)>.size(of:): \(MemoryLayout<F>.size(ofValue: f) * bitsPerByte)")
                print("\(F.self).nonzeroBitCount: \(f.nonzeroBitCount)")
                print("\(F.self).leadingZeroBitCount: \(f.leadingZeroBitCount)")
                print("\(F.self).trailingZeroBitCount: \(f.trailingZeroBitCount)")
            }
            
            XCTAssert(
                f.bitWidth == expectedBitWidth,
                "Expected bitWidth = \(expectedBitWidth)"
            )
            XCTAssert(
                MemoryLayout<F>.size * bitsPerByte == expectedBitWidth,
                "Expected MemoryLayout<F>.size * bitsPerByte = \(expectedBitWidth) (type: \(F.self))"
            )
            
            XCTAssert(
                f.byteWidth == expectedByteWidth,
                "Expected byteWidth = \(expectedByteWidth) actutal \(f.byteWidth) (type: \(F.self))"
            )
            
            XCTAssert(
                MemoryLayout<F>.size == expectedByteWidth,
                "Expected MemoryLayout<F>.size == \(expectedByteWidth) actual: \(MemoryLayout<F>.size) (type: \(F.self))"
            )
            
            XCTAssert(
                f.binaryString == expectedBinaryString,
                "Expected binaryString = \(expectedBinaryString) actual: \(f.binaryString) (type: \(F.self))"
            )
            
            XCTAssert(
                f.decimalString == expectedDecimalString,
                "Expected decimalString = \(expectedDecimalString) actual: \(f.decimalString) (type: \(F.self))"
            )
            
            XCTAssert(
                f.hexString == expectedHexString,
                "Expected hexString = \(expectedHexString) actual: \(f.hexString) (type: \(F.self))"
            )
        }
        
        examine(
            f: UInt8(0xAB),
            expectedBitWidth: 8,
            expectedByteWidth: 1,
            expectedBinaryString: Radix.binary.prefix + "10101011",
            expectedDecimalString: Radix.decimal.prefix + "171",
            expectedHexString: Radix.hexadecimal.prefix + "AB"
        )
        
        examine(
            f: UInt8(0xAB),
            expectedBitWidth: 8,
            expectedByteWidth: 1,
            expectedBinaryString: Radix.binary.prefix + "10101011",
            expectedDecimalString: Radix.decimal.prefix + "171",
            expectedHexString: Radix.hexadecimal.prefix + "AB"
        )

        examine(
            f: UInt16(0xABCD),
            expectedBitWidth: 16,
            expectedByteWidth: 2,
            expectedBinaryString: Radix.binary.prefix + "1010101111001101",
            expectedDecimalString: Radix.decimal.prefix + "43981",
            expectedHexString: Radix.hexadecimal.prefix + "ABCD"
        )
        
        examine(
            f: UInt16(0x0001),
            expectedBitWidth: 16,
            expectedByteWidth: 2,
            expectedBinaryString: Radix.binary.prefix + "0000000000000001",
            expectedDecimalString: Radix.decimal.prefix + "1",
            expectedHexString: Radix.hexadecimal.prefix + "0001"
        )

        examine(
            f: UInt32(0xABCDEFFE),
            expectedBitWidth: 32,
            expectedByteWidth: 4,
            expectedBinaryString: Radix.binary.prefix + "10101011110011011110111111111110",
            expectedDecimalString: Radix.decimal.prefix + "2882400254",
            expectedHexString: Radix.hexadecimal.prefix + "ABCDEFFE"
        )

        examine(
            f: UInt64(0xABCDEF0110FEDCBA),
            expectedBitWidth: 64,
            expectedByteWidth: 8,
            expectedBinaryString: Radix.binary.prefix + "1010101111001101111011110000000100010000111111101101110010111010",
            expectedDecimalString: Radix.decimal.prefix + "12379813738570505402",
            expectedHexString: Radix.hexadecimal.prefix + "ABCDEF0110FEDCBA"
        )
        
        examine(
            f: UInt(0xABCDEF0110FEDCBA),
            expectedBitWidth: 64,
            expectedByteWidth: 8,
            expectedBinaryString: Radix.binary.prefix + "1010101111001101111011110000000100010000111111101101110010111010",
            expectedDecimalString: Radix.decimal.prefix + "12379813738570505402",
            expectedHexString: Radix.hexadecimal.prefix + "ABCDEF0110FEDCBA"
        )
    }
    
    func testFixedWidthIntegerToBinaryString() throws {
        let types = TestDataPoints.types
        let binaryStrings = TestDataPoints.radixStringSets.map { $0.binaryString }

        for inputRadixString in binaryStrings {
            for type in types {
                guard let v = type.init(binaryString: inputRadixString) else {
                    // Number of bytes the binaryString represents as an unsigned int (remove "0b")
                    let binaryStringBitWidth = (inputRadixString.count - 2)
                    // Number of bytes the type represents when holding an unsigned int
                    let typeUnsignedBitWidth = Int(type.unsignedBitWidth)
                    XCTAssertGreaterThanOrEqual(
                        binaryStringBitWidth,
                        typeUnsignedBitWidth,
                        """
                        Failed to convert \(inputRadixString) to \(type).
                        type: \(type) typeUnsignedBitWidth: \(typeUnsignedBitWidth) binaryString: \(inputRadixString) binaryStringBitWidth: \(binaryStringBitWidth)
                        """
                    )
                    continue
                }
                
                // Let's pad the test input radixString with the appropriate number of
                // leading 0's to match `type`.
                let reconstitutedRadixString = v.binaryString
                
                // Let's pad the test input radixString with the appropriate number of
                // leading 0's to match `type`.
                let nakedRadixString = inputRadixString.replacingOccurrences(of: Radix.binary.prefix, with: "")
                let trimmedRadixString = String(nakedRadixString.dropFirst(max(0, nakedRadixString.count - type.bitWidth)))
                let paddedRadixString = trimmedRadixString.padding(length: type.bitWidth, character: "0", endfix: .prefix)
                let prefixedRadixString = Radix.binary.prefix + paddedRadixString
                
                XCTAssertEqual(
                    prefixedRadixString,
                    reconstitutedRadixString,
                    "type: \(type) expected: \(prefixedRadixString) actual: \(reconstitutedRadixString)"
                )
                print("binaryString type: \(type) expected: \(prefixedRadixString) actual: \(reconstitutedRadixString)")
            }
        }
    }
    
    func testFixedWidthIntegerToHexString() throws {
        let types = TestDataPoints.types
        let hexStrings = TestDataPoints.radixStringSets.map { $0.hexString }
        for inputRadixString in hexStrings {
            for type in types {
                guard let v = type.init(hexString: inputRadixString) else {
                    // Number of bytes the hexString represents as an unsigned int (remove "0x")
                    let hexStringBitWidth = (inputRadixString.count - 2) * 4
                    // Number of bytes the type represents when holding an unsigned int
                    let typeUnsignedBitWidth = Int(type.unsignedBitWidth)
                    XCTAssertGreaterThanOrEqual(
                        hexStringBitWidth,
                        typeUnsignedBitWidth,
                        """
                        Failed to convert \(inputRadixString) to \(type).
                        type: \(type) typeUnsignedBitWidth: \(typeUnsignedBitWidth) hexString: \(inputRadixString) hexStringBitWidth: \(hexStringBitWidth)
                        """
                    )
                    continue
                }
                
                let base = Radix.hexadecimal.stripPrefix(inputRadixString)
                let trimmed = String(base.suffix(type.byteWidth * 2))
                let paddedBase = trimmed.padding(length: type.byteWidth * 2, character: "0", endfix: .prefix)
                let expected = Radix.hexadecimal.appendPrefix(paddedBase)
                let actual = v.hexString
                
                XCTAssertEqual(
                    expected,
                    actual,
                    "type: \(type) type.byteWidth: \(type.byteWidth), expected: \(expected), actual: \(actual), base: \(base), paddedBase: \(paddedBase), expected: \(expected)"
                )
            }
        }
    }
}
