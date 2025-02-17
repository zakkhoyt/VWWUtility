//
//  DataTests.swift
//
//  Created by Zakk Hoyt on 2024.
//

import Foundation
@testable import RadixUtilities
import XCTest

final class DataTests: XCTestCase {
    /// Tests `Data(hexString:)` and `data.hexString` where input strings are valid hexStrings
    func testInitFromHexStrings() throws {
        let hexStrings = TestDataPoints.radixStringSets.map { $0.hexString }
        for inputRadixString in hexStrings {
            let data: Data = try XCTUnwrap(Data(hexString: inputRadixString))
            let expected = inputRadixString
            let actual = data.hexString
            XCTAssertEqual(actual, expected, "expected \(expected), actual: \(actual)")
        }
    }
    
    /// Tests `Data(hexString:)` and `data.hexString` where input strings contain non-hexString characters
    func testInitFromHexStringsWithNoise() throws {
        let hexStrings = TestDataPoints.radixStringSets.map { $0.hexString }
        for inputRadixString in hexStrings {
            for i in 0..<3 {
                let noisyString: String = switch i {
                case 0:
                    "xyz$*%^" + inputRadixString
                case 1:
                    inputRadixString + "%(&^%zz"
                default:
                    inputRadixString
                }
                let data: Data = try XCTUnwrap(Data(hexString: noisyString))
                let expected = inputRadixString
                let actual = data.hexString
                XCTAssertEqual(actual, expected, "expected \(expected), actual: \(actual)")
            }
        }
    }

    func testSwapAndUnpackUInt8() throws {
        let expected = 0xFF
        let data = Data(hexString: "0xFF")
        let actual: UInt8 = try XCTUnwrap(data.swapAndUnpack())
        XCTAssertEqual(expected, expected, "expected \(expected), actual: \(actual)")
    }

    func testSwapAndUnpackLargeUInt8() throws {
        let expected = 0xFF
        let data = Data(hexString: "0x88FF")
        let actual: UInt8 = try XCTUnwrap(data.swapAndUnpack())
        XCTAssertEqual(expected, expected, "expected \(expected), actual: \(actual)")
    }
    
    // Tying to cast 0 bytes to 1 byte UInt64. Expect throwing error
    func testSwapAndUnpackUInt8Throws() throws {
        // This is an alternative to using XCTAssertThrowsError
        // which doesn't seem to support generic functions that
        // infer return type.
        let data = Data(hexString: "0x")
        XCTExpectFailure("Expecting data.swapAndUnpack() to throw an error")
        let _: UInt8 = try data.swapAndUnpack()
    }
    
    func testSwapAndUnpackUInt64() throws {
        let expected: UInt64 = 0xFFFFFFFFFFFFFFFF
        let data = Data(hexString: "0xFFFFFFFFFFFFFFFF")
        let actual: UInt64 = try XCTUnwrap(data.swapAndUnpack())
        XCTAssertEqual(expected, expected, "expected \(expected), actual: \(actual)")
    }
    
    func testSwapAndUnpackLargeUInt64() throws {
        let expected: UInt64 = 0xFFFFFFFFFFFFFFFF
        let data = Data(hexString: "0x112233FFFFFFFFFFFFFFFF")
        let actual: UInt64 = try XCTUnwrap(data.swapAndUnpack())
        XCTAssertEqual(expected, expected, "expected \(expected), actual: \(actual)")
    }

    // Tying to cast 7 bytes to 8 byte UInt64. Expect throwing error
    func testSwapAndUnpackUInt64Throws() throws {
        // This is an alternative to using XCTAssertThrowsError
        // which doesn't seem to support generic functions that
        // infer return type.
        let data = Data(hexString: "0xFFFFFFFFFFFFFF")
        XCTExpectFailure("Expecting data.swapAndUnpack() to throw an error")
        let _: UInt64 = try data.swapAndUnpack()
    }

    func testHexStringPrefix() {
        let input = "0xFFFFFFFFFFFFFFFF"
        let data = Data(hexString: input)
        let actual = data.hexString()
        let expected = input
        XCTAssertEqual(expected, actual, "expected \(expected), actual: \(actual)")
    }

    func testHexStringNoPrefix() {
        let input = "0xFFFFFFFFFFFFFFFF"
        let data = Data(hexString: input)
        let actual = data.hexString(includePrefix: false)
        let expected = Radix.hexadecimal.stripPrefix(input)
        XCTAssertEqual(expected, actual, "expected \(expected), actual: \(actual)")
    }
}
