//
//  ANSIUtilitiesTests.swift
//  ANSIUtilitiesTests
//
//  Tests for ANSIUtilities library
//

import XCTest
@testable import ANSIUtilities

final class ANSIUtilitiesTests: XCTestCase {
    
    // MARK: - ANSI Enum Tests
    
    func testDefaultCase() {
        let ansi = ANSI.default
        XCTAssertEqual(ansi.constant, "0")
        XCTAssertEqual(ansi.numberOfValues, 0)
    }
    
    func testForegroundColors() {
        XCTAssertEqual(ANSI.redForeground.constant, "31")
        XCTAssertEqual(ANSI.greenForeground.constant, "32")
        XCTAssertEqual(ANSI.blueForeground.constant, "34")
        XCTAssertEqual(ANSI.yellowForeground.constant, "33")
    }
    
    func testBackgroundColors() {
        XCTAssertEqual(ANSI.redBackground.constant, "41")
        XCTAssertEqual(ANSI.greenBackground.constant, "42")
        XCTAssertEqual(ANSI.blueBackground.constant, "44")
    }
    
    func testBrightForegroundColors() {
        XCTAssertEqual(ANSI.brightRedForeground.constant, "91")
        XCTAssertEqual(ANSI.brightGreenForeground.constant, "92")
        XCTAssertEqual(ANSI.brightBlueForeground.constant, "94")
    }
    
    func testRGBForegroundHasCorrectNumberOfValues() {
        let ansi = ANSI.rgbForeground
        XCTAssertEqual(ansi.numberOfValues, 3)
        XCTAssertEqual(ansi.constant, "38;2;")
    }
    
    func testEightBitForegroundHasCorrectNumberOfValues() {
        let ansi = ANSI.eightBitForeground
        XCTAssertEqual(ansi.numberOfValues, 1)
        XCTAssertEqual(ansi.constant, "38;5;")
    }
    
    // MARK: - ANSI.Item Tests
    
    func testItemInitWithSimpleForeground() {
        let item = ANSI.Item(.redForeground)
        XCTAssertEqual(item.ansi, .redForeground)
        XCTAssertTrue(item.values.isEmpty)
    }
    
    func testItemInitWithValues() {
        // RGB foreground requires 3 values
        let rgbItem = ANSI.Item(.rgbForeground, values: [255, 100, 50])
        XCTAssertEqual(rgbItem.ansi, .rgbForeground)
        XCTAssertEqual(rgbItem.values, [255, 100, 50])
        
        // 8-bit foreground requires 1 value
        let eightBitItem = ANSI.Item(.eightBitForeground, values: [196])
        XCTAssertEqual(eightBitItem.ansi, .eightBitForeground)
        XCTAssertEqual(eightBitItem.values, [196])
    }
    
    // MARK: - ANSI.Style Tests
    
    func testStyleDecoration() {
        let style: ANSI.Style = [.redForeground]
        let decorated = ANSI.UI.decorate(text: "Hello", style: style)
        XCTAssertTrue(decorated.contains("Hello"))
        XCTAssertTrue(decorated.contains("\u{001B}["))
    }
    
    // MARK: - ANSI.UI Tests
    
    func testUIDecorateWithSingleItem() {
        let decorated = ANSI.UI.decorate(text: "Test", items: [ANSI.Item(.redForeground)])
        XCTAssertTrue(decorated.contains("Test"))
        XCTAssertTrue(decorated.contains("\u{001B}[31m"))
    }
    
    func testUIDecorateWithMultipleItems() {
        let decorated = ANSI.UI.decorate(text: "Test", items: [ANSI.Item(.redForeground), ANSI.Item(.boldFont)])
        XCTAssertTrue(decorated.contains("Test"))
        XCTAssertTrue(decorated.contains("\u{001B}["))
    }
}
