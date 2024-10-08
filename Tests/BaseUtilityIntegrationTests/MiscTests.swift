//
//  MiscTests.swift
//
//
//  Created by Zakk Hoyt on 6/7/24.
//

import BaseUtility
import XCTest

final class MiscTests: XCTestCase {
    
    func testNilOptionalString() {
        let text: String? = nil
        let expected = "<n/a>"
        XCTAssertEqual(text.optionalString, expected)
    }
    
    func testOptionalString() {
        let text: String? = "MyString"
        let expected = "MyString"
        XCTAssertEqual(text.optionalString, expected)
        XCTAssertEqual(String(describing: text.optionalString), expected)
        XCTAssertEqual(text, expected)
    }
}
