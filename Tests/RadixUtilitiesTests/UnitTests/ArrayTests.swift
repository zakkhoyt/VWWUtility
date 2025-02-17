//
//  ArrayTests.swift
//
//  Created by Zakk Hoyt on 2024-12-04.
//  Copyright hatch.co, 2024.
//

import Foundation
@testable import HatchRadixUtilities
import XCTest

class ArrayTests: XCTestCase {
    func testHexStringToDataToHexString() {
        let hexString = [
            Radix.hexadecimal.prefix,
            "01F83F73630E7F5A000000FF01FF9ED35D007FDF0754696D6520746F205269736500000000"
        ].joined()
        
        // Convert hexString to Data then compare hexString representation
        let data: Data = hexString.replacingOccurrences(
            of: Radix.hexadecimal.prefix,
            with: ""
        ).data
        XCTAssertEqual(hexString, data.hexString)
    }

    func testHexStringToBytesArrayToHexString() {
        let hexString = [
            Radix.hexadecimal.prefix,
            "01F83F73630E7F5A000000FF01FF9ED35D007FDF0754696D6520746F205269736500000000"
        ].joined()
        
        // Convert hexString to [UInt8] then compare hexString representation
        let bytes: [UInt8] = hexString.replacingOccurrences(
            of: Radix.hexadecimal.prefix,
            with: ""
        ).bytes
        XCTAssertEqual(hexString, bytes.hexString)
    }
    
    func testArrayToHexString() {
        let array: [UInt8] = [0x01, 0xF8, 0x3F, 0x73, 0x63, 0x0E, 0x7F, 0x5A]

        do {
            let actual = array.hexString
            let expected = "0x01F83F73630E7F5A"
            XCTAssertEqual(expected, actual, "expected \(expected), actual \(actual)")
        }

        do {
            let actual = array.hexString()
            let expected = "0x01F83F73630E7F5A"
            XCTAssertEqual(expected, actual, "expected \(expected), actual \(actual)")
        }
        
        do {
            let actual = array.hexString(includePrefix: false)
            let expected = "01F83F73630E7F5A"
            XCTAssertEqual(expected, actual, "expected \(expected), actual \(actual)")
        }
    }
    
    func testArrayToHexStringVar() {
        var array: [UInt8] = [0x01, 0xF8, 0x3F, 0x73, 0x63, 0x0E, 0x7F, 0x5A]
        let data = Data(bytes: &array, count: array.count)
        
        do {
            let actual = data.hexString
            let expected = "0x01F83F73630E7F5A"
            XCTAssertEqual(expected, actual, "expected \(expected), actual \(actual)")
        }
        
        do {
            let actual = data.hexString()
            let expected = "0x01F83F73630E7F5A"
            XCTAssertEqual(expected, actual, "expected \(expected), actual \(actual)")
        }
        
        do {
            let actual = data.hexString(includePrefix: false)
            let expected = "01F83F73630E7F5A"
            XCTAssertEqual(expected, actual, "expected \(expected), actual \(actual)")
        }
    }
}
