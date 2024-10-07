//
//  HexStringTests.swift
//
//
//  Created by Zakk Hoyt on 7/27/23.
//

import BaseUtility
import XCTest

final class HexStringTests: XCTestCase {
    func testHexStringPrimitives() throws {
        let bitsPerByte = 8
        func examine<F: FixedWidthInteger>(
            f: F,
            expectedBitWidth: Int,
            expectedByteWidth: Int,
            expectedBinaryString: String,
            expectedHexString: String
        ) {
            print("---- ---- ---- ----")
            
            print("\(F.self).bitWidth: \(f.bitWidth)")
            XCTAssert(f.bitWidth == expectedBitWidth, "Expected bitWidth = \(expectedBitWidth)")
            XCTAssert(MemoryLayout<F>.size * bitsPerByte == expectedBitWidth, "Expected MemoryLayout<F>.size * bitsPerByte = \(expectedBitWidth)")
            
            print("\(F.self).byteWidth: \(f.byteWidth)")
            XCTAssert(f.byteWidth == expectedByteWidth, "Expected byteWidth = \(expectedByteWidth)")
            XCTAssert(MemoryLayout<F>.size == expectedByteWidth, "Expected MemoryLayout<F>.size = \(expectedByteWidth)")
            
            print("----")
            print("\(F.self).binaryString: \(f.binaryString)")
            XCTAssert(f.binaryString == expectedBinaryString, "Expected byteWidth = \(expectedBinaryString). Actual: \(f.binaryString)")

            print("\(F.self).hexString: \(f.hexString)")
            XCTAssert(f.hexString == expectedHexString, "Expected hexString = \(expectedHexString). Actual: \(f.hexString)")

            print("----")
            //            print("MemoryLayout<\(F.self)>.size: \(MemoryLayout<F>.size * bitsPerByte)")
            //            print("MemoryLayout<\(F.self)>.size(of:): \(MemoryLayout<F>.size(ofValue: f) * bitsPerByte)")
            print("\(F.self).nonzeroBitCount: \(f.nonzeroBitCount)")
            print("\(F.self).leadingZeroBitCount: \(f.leadingZeroBitCount)")
            print("\(F.self).trailingZeroBitCount: \(f.trailingZeroBitCount)")
        }

        examine(
            f: UInt8(0xAB),
            expectedBitWidth: 8,
            expectedByteWidth: 1,
            expectedBinaryString: "0b10101011",
            expectedHexString: "0xAB"
        )

        examine(
            f: UInt16(0xABCD),
            expectedBitWidth: 16,
            expectedByteWidth: 2,
            expectedBinaryString: "0b1010101111001101",
            expectedHexString: "0xABCD"
        )
        
        examine(
            f: UInt16(0x0001),
            expectedBitWidth: 16,
            expectedByteWidth: 2,
            expectedBinaryString: "0b0000000000000001",
            expectedHexString: "0x0001"
        )

        examine(
            f: UInt32(0xABCDEFFE),
            expectedBitWidth: 32,
            expectedByteWidth: 4,
            expectedBinaryString: "0b10101011110011011110111111111110",
            expectedHexString: "0xABCDEFFE"
        )

        examine(
            f: UInt64(0xABCDEF0110FEDCBA),
            expectedBitWidth: 64,
            expectedByteWidth: 8,
            expectedBinaryString: "0b1010101111001101111011110000000100010000111111101101110010111010",
            expectedHexString: "0xABCDEF0110FEDCBA"
        )
        
        examine(
            f: UInt(0xABCDEF0110FEDCBA),
            expectedBitWidth: 64,
            expectedByteWidth: 8,
            expectedBinaryString: "0b1010101111001101111011110000000100010000111111101101110010111010",
            expectedHexString: "0xABCDEF0110FEDCBA"
        )

//        examine(f: Int8(bitPattern: 0xAB))
//        examine(f: Int16(bitPattern: 0xABCD))
//        examine(f: Int32(bitPattern: 0xABCDEFFE))
//        examine(f: Int64(bitPattern: 0xABCDEF0110FEDCBA))
//        examine(f: Int(bitPattern: 0xABCDEF0110FEDCBA))
    }
    
    func testFixedWidthIntegerToHexString() throws {
        let types: [any FixedWidthInteger.Type] = [
            UInt8.self,
            UInt16.self,
            UInt32.self,
            UInt64.self,
            Int8.self,
            Int16.self,
            Int32.self,
            Int64.self
        ]
        
        let hexStrings = [
            "0x7F",
            "0xFF",
            "0xFF00",
            "0xFF000000",
            "0xFF00000000000000",
            "0xFFFFFFFFFFFFFFFF"
        ]
        
        for hexString in hexStrings {
            for type in types {
                guard let v = type.init(hexString: hexString) else {
                    // Number of bytes the hexString represents as an unsigned int (remove "0x")
                    let hexStringBitWidth = (hexString.count - 2) * 4
                    // Number of bytes the type represents when holding an unsigned int
                    let typeUnsignedBitWidth = Int(type.unsignedBitWidth)
                    XCTAssertGreaterThanOrEqual(
                        hexStringBitWidth,
                        typeUnsignedBitWidth,
                        """
                        Failed to convert \(hexString) to \(type).
                        type: \(type) typeUnsignedBitWidth: \(typeUnsignedBitWidth) hexString: \(hexString) hexStringBitWidth: \(hexStringBitWidth)
                        """
                    )
                    continue
                }
                
                // So far hexString has been converted to an int type.
                // Let's convert back to hexString then compare against original.
                
                // Let's pad the original hexString with the appropriate number of
                // leading 0's to match `type`.
                let nakedHexString = hexString.replacingOccurrences(of: "0x", with: "")
                let length: Int = type.bitWidth / 4
                let buffedHexString = nakedHexString.padded(length: length, character: "0", endfix: .prefix)
                let paddedHexString = "0x\(buffedHexString)"
                let reconstitutedHexString = v.hexString
                XCTAssertEqual(paddedHexString, reconstitutedHexString, "type: \(type) expected: \(paddedHexString) actual: \(reconstitutedHexString)")
            }
        }
    }
    
    func testFixedWidthIntegerToBinaryString() throws {
        let types: [any FixedWidthInteger.Type] = [
            UInt8.self,
            UInt16.self,
            UInt32.self,
            UInt64.self,
            Int8.self,
            Int16.self,
            Int32.self,
            Int64.self
        ]
        
        let binaryStrings = [
            "0b01111111",
            "0b11111111",
            "0b1111111100000000",
            "0b11111111000000000000000000000000",
            "0b1111111100000000000000000000000000000000000000000000000000000000",
            "0b1111111111111111111111111111111111111111111111111111111111111111"
        ]
        
        for binaryString in binaryStrings {
            for type in types {
                guard let v = type.init(binaryString: binaryString) else {
                    // Number of bytes the binaryString represents as an unsigned int (remove "0b")
                    let binaryStringBitWidth = (binaryString.count - 2)
                    // Number of bytes the type represents when holding an unsigned int
                    let typeUnsignedBitWidth = Int(type.unsignedBitWidth)
                    XCTAssertGreaterThanOrEqual(
                        binaryStringBitWidth,
                        typeUnsignedBitWidth,
                        """
                        Failed to convert \(binaryString) to \(type).
                        type: \(type) typeUnsignedBitWidth: \(typeUnsignedBitWidth) binaryString: \(binaryString) binaryStringBitWidth: \(binaryStringBitWidth)
                        """
                    )
                    continue
                }
                
                // So far binaryString has been converted to an int type.
                // Let's convert back to binaryString then compare against original.
                
                // Let's pad the original binaryString with the appropriate number of
                // leading 0's to match `type`.
                let nakedHexString = binaryString.replacingOccurrences(of: "0b", with: "")
                let length: Int = type.bitWidth
                let buffedHexString = nakedHexString.padded(length: length, character: "0", endfix: .prefix)
                let paddedHexString = "0b\(buffedHexString)"
                let reconstitutedHexString = v.binaryString
                XCTAssertEqual(paddedHexString, reconstitutedHexString, "type: \(type) expected: \(paddedHexString) actual: \(reconstitutedHexString)")
            }
        }
    }
}
