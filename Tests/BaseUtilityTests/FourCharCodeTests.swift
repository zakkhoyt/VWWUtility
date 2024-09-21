//
//  FourCharCodeTests.swift
//
//
//  Created by Zakk Hoyt
//

import BaseUtility
import XCTest
import CoreMedia

final class FourCharCodeTests: XCTestCase {
    func testAVMediaType() throws {
#warning("FIXME: zakkhoyt - implement this test")
//        let input = "aaac"
//        let fourCharCode: FourCharCode = try input.fourCharCode
//        let output = CMFormatDescription.MediaSubType(rawValue: fourCharCode)
//        XCTAssertEqual(input, output.rawValue.stringRepresentation)
    }

    func testCMFormatDescriptionMediaType() throws {
#warning("FIXME: zakkhoyt - implement this test")
//        let input = "aaac"
//        let fourCharCode: FourCharCode = try input.fourCharCode
//        let output = CMFormatDescription.MediaSubType(rawValue: fourCharCode)
//        XCTAssertEqual(input, output.rawValue.stringRepresentation)
    }

    func testCMFormatDescriptionMediaSubType() throws {
        let input = "aaac"
        let fourCharCode: FourCharCode = try input.fourCharCode
        let output = CMFormatDescription.MediaSubType(rawValue: fourCharCode)
        XCTAssertEqual(input, output.rawValue.stringRepresentation)
    }
}
