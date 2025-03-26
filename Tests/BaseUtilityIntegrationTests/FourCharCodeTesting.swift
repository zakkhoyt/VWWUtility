//
// FourCharCodeTesting.swift
// VWWUtility
//
// Created by Zakk Hoyt on 2024-09-22.
//
@testable import BaseUtility
import CoreFoundation
import CoreMedia
import Testing

struct FourCharCodeTesting {
    @Test
    func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
    
    @Test @MainActor
    func example2() async throws {}
    
    @available(macOS 11.0, *)
    @available(swift, introduced: 8.0, message: "Requires Swift 8.0 features to run")
    @Test @MainActor
    func example3() async throws {}
    
//    @Test func calculatingOrderTotal() {
//        let calculator = OrderCalculator()
//        #expect(calculator.total(of: [3, 3]) == 7)
//        // Prints "Expectation failed: (calculator.total(of: [3, 3]) → 6) == 7"
//    }
//
//    @Test func returningCustomerRemembersUsualOrder() throws {
//        let customer = try #require(Customer(id: 123))
//        // The test runner doesn't reach this line if the customer is nil.
//        #expect(customer.usualOrder.countOfItems == 2)
//    }
    
    @available(macOS 15.0, iOS 18.0, *)
    @Test
    func testCMFormatDescriptionMediaSubType() throws {
        let sourceLocation: SourceLocation = #_sourceLocation
        print("sourceLocation.description: \(sourceLocation.description)")
        print("sourceLocation.debugDescription: \(sourceLocation.debugDescription)")
        
        let fakeSourceLocation = SourceLocation(
            fileID: #fileID,
            filePath: #filePath,
            line: #line,
            column: #column
        )
        print("fakeSourceLocation.description: \(fakeSourceLocation.description)")
        print("fakeSourceLocation.debugDescription: \(fakeSourceLocation.debugDescription)")

        let input = "aaac"
        let fourCharCode: FourCharCode = try input.fourCharCode
        let output = CMFormatDescription.MediaSubType(rawValue: fourCharCode)
        #expect(input == output.rawValue.stringRepresentation, "nope!")
        print("This this line after failed #expect?")
        
        try #require(
            input == output.rawValue.stringRepresentation
        )
        
        print("This line should not be executed (after a failed #require)")
    }
}
