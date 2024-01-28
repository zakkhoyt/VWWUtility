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
        // FixedWidthInteger
//        let a: UInt8 = 0xFF
//        print("UInt8.bitWidth: \(a.bitWidth)")
//        print("UInt8.nonzeroBitCount: \(a.nonzeroBitCount)")
//        print("UInt8.leadingZeroBitCount: \(a.leadingZeroBitCount)")
//        print("UInt8.trailingZeroBitCount: \(a.trailingZeroBitCount)")
        
//        print("MemoryLayout<UInt8>.size: \(MemoryLayout<UInt8>.size * bitsPerByte)")
//        print("MemoryLayout<UInt8>.size(of:): \(MemoryLayout<UInt8>.size(ofValue: a) * bitsPerByte)")

        func examine<F: FixedWidthInteger>(
            f: F,
            expectedBitWidth: Int,
            expectedByteWidth: Int,
            expectedBinaryString: String,
            expectedHexString: String
        ) {
            // FixedWidthInteger
            // let a: UInt8 = 0xFF
            print("---- ---- ---- ----")
//            print("\(F.self).words: \(f.words)")
            
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
    
    //        UInt8(0xAB).test()
    //        UInt16(0xABCD).test()
    //        UInt32(0xABCDEFFE).test()
    //        UInt64(0xABCDEF0110FEDCBA).test()
    //        UInt(0xABCDEF0110FEDCBA).test()
    //
    //        Int8(bitPattern: 0xAB).test()
    //        Int16(bitPattern: 0xABCD).test()
    //        Int32(bitPattern: 0xABCDEFFE).test()
    //        Int64(bitPattern: 0xABCDEF0110FEDCBA).test()
    //        Int(bitPattern: 0xABCDEF0110FEDCBA).test()
}

// let bitsPerByte = 8
// extension FixedWidthInteger {
//
//    var byteWidth: Int {
//        bitWidth / 8
//    }
//
//    var binaryString: String {
//        "0b" + (0..<(Self.bitWidth / 8)).reduce(into: []) { // partialResult, Int in
//            let byteString = String(
//                UInt8(truncatingIfNeeded: self >> ($1 * 8)),
//                radix: 2
//            )
//            let padding = String(
//                repeating: "0",
//                count: 8 - byteString.count
//            )
//            $0.append(padding + byteString)
//        }.reversed().joined(separator: "")
//
//
//    }
// }

extension FixedWidthInteger {
//    func test() {
//        //FixedWidthInteger
//        //let a: UInt8 = 0xFF
//        print("---- ---- ---- ----")
//        print("\(Self.self).words: \(self.words)")
//        print("\(Self.self).bitWidth: \(self.bitWidth)")
//        print("MemoryLayout<\(Self.self)>.size: \(MemoryLayout<Self>.size * bitsPerByte)")
//        print("MemoryLayout<\(Self.self)>.size(of:): \(MemoryLayout<Self>.size(ofValue: self) * bitsPerByte)")
//
//        print("----")
//        print("\(Self.self).binaryString: \(self.binaryString)")
//        print("----")
//        print("\(Self.self).nonzeroBitCount: \(self.nonzeroBitCount)")
//        print("\(Self.self).leadingZeroBitCount: \(self.leadingZeroBitCount)")
//        print("\(Self.self).trailingZeroBitCount: \(self.trailingZeroBitCount)")
//
//    }
}
