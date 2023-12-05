//
//  DecodingErrorTests.swift
//
//  Created by Zakk Hoyt on 11/7/23.
//

import BaseUtility
import XCTest

final class DecodingErrorTests: XCTestCase {
    struct MyStruct: Codable, Equatable {
        struct MyNestedStruct: Codable, Equatable {
            let color: String
            let count: Int
        }
        
        let name: String
        let age: Int
        let nested: MyNestedStruct
    }

    let instance = MyStruct(
        name: "My Name",
        age: 44,
        nested: MyStruct.MyNestedStruct(
            color: "red",
            count: 100
        )
    )
    let valid_json = #"{"nested":{"color":"red","count":100},"age":44,"name":"My Name"}"#
    
    /// Includes an unwanted key/value which should technically be ignored
    let valid_json_superflouous_key_value = #"{"unwanted_key": 0, "nested":{"color":"red","count":100},"age":44,"name":"My Name"}"#
    
    /// Missing key/value for `nested.count`
    ///
    /// **Example:**
    ///
    /// ```swift
    /// DecodingError
    /// error: The data couldn’t be read because it is missing.
    /// subject: keyNotFound: CodingKeys(stringValue: "count", intValue: nil)
    /// context: No value associated with key CodingKeys(stringValue: "count", intValue: nil) ("count").
    /// codingPath: nested
    /// ```
    let invalid_json_missing_key = #"{"nested":{"color":"red"},"age":44,"name":"My Name"}"#
    
    /// Age is a string instead of int.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// DecodingError
    /// error: The data couldn’t be read because it isn’t in the correct format.
    /// subject: typeMismatch: Int
    /// context: Expected to decode Int but found a string instead.
    /// codingPath: age
    /// ```
    let invalid_json_wrong_type = #"{"nested":{"color":"red","count":100},"age":"44","name":"My Name"}"#
    
    /// `nested.count` is a string instead of int.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// DecodingError
    /// error: The data couldn’t be read because it isn’t in the correct format.
    /// subject: typeMismatch: Int
    /// context: Expected to decode Int but found a string instead.
    /// codingPath: nested.count
    /// ```
    let invalid_json_wrong_type_nested = #"{"nested":{"color":"red","count":"100"},"age":44,"name":"My Name"}"#

    func testDecodableValid() throws {
        try expectDecodable(
            jsonString: valid_json,
            expectedInstance: instance
        )
    }
    
    func testDecodableSuperfluousKeyValue() throws {
        try expectDecodable(
            jsonString: valid_json_superflouous_key_value,
            expectedInstance: instance
        )
    }
    
    func testDecodingErrorMissingKey() throws {
        try expectDecodingError(
            jsonString: invalid_json_missing_key,
            errorSnippet: #"No value associated with key CodingKeys(stringValue: "count", intValue: nil) ("count")."#
        )
    }

    func testDecodingErrorWrongType() throws {
        try expectDecodingError(
            jsonString: invalid_json_wrong_type,
            errorSnippet: "codingPath: age"
        )
    }
    
    func testDecodingErrorWrongTypeNested() throws {
        try expectDecodingError(
            jsonString: invalid_json_wrong_type_nested,
            errorSnippet: "codingPath: nested.count"
        )
    }
    
    // MARK: Private functions
    
    /// Decodes `jsonString` then compares against `expectedInstance`
    /// - Parameters:
    ///   - jsonString: Json string to decode as `MyStruct.self`
    ///   - expectedInstance: An instance of `MyStruct` to compare the decoded instance with.
    private func expectDecodable(
        jsonString: String,
        expectedInstance: MyStruct
    ) throws {
        let decoder = JSONDecoder()
        let data = try XCTUnwrap(jsonString.data(using: .utf8))
        let decodedInstance = try decoder.decode(MyStruct.self, from: data)
        XCTAssertEqual(decodedInstance, expectedInstance)
    }
    
    /// Decodes jsonString expecting that a DecodingError will be thrown.
    /// Then expects to find `errorSnippet` in the `error.debugDescription`
    /// - Parameters:
    ///   - jsonString: The jsonString to decode
    ///   - errorSnippet: A substring expected to be found in `error.debugDescription`
    private func expectDecodingError(
        jsonString: String,
        errorSnippet: String
    ) throws {
        let decoder = JSONDecoder()
        let data = try XCTUnwrap(jsonString.data(using: .utf8))
        do {
            let decodedInstance = try decoder.decode(MyStruct.self, from: data)
            XCTFail("Expected EecodingError to be thrown")
            XCTAssertEqual(decodedInstance, instance)
        } catch let error as DecodingError {
            print(error.debugDescription)
            XCTAssertTrue(error.debugDescription.contains(errorSnippet))
        } catch {
            XCTFail("Expected DecodingError, got other type of error: \(error.localizedDescription)")
        }
    }
}
