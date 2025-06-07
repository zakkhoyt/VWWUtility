//
//  EncodingErrorUnitTests.swift
//
//  Created by Zakk Hoyt on 11/7/23.
//

@testable import CodableUtilities
import XCTest

final class EncodingErrorUnitTests: XCTestCase {
    /// This is a base class where subclasses can override `func encode(encoder:)`
    private class BaseClass: Codable, Equatable {
        init(
            name: String,
            age: Int
        ) {
            self.name = name
            self.age = age
        }
        
        static func == (
            lhs: EncodingErrorUnitTests.BaseClass,
            rhs: EncodingErrorUnitTests.BaseClass
        ) -> Bool {
            lhs.name == rhs.name && lhs.age == rhs.age
        }
        
        let name: String
        let age: Int
        
        enum CodingKeys: String, CodingKey {
            case name
            case age
        }
        
        func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(name, forKey: .name)
            try container.encode(age, forKey: .age)
        }
    }
    
    /// Expects value Encodable. This is mainly to validate `BaseClass`
    func testEncoding() throws {
        class MyClass: BaseClass {}
        let instance = MyClass(
            name: "My Name",
            age: 44
        )
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        do {
            let data = try encoder.encode(instance)
            let jsonString = try XCTUnwrap(String(data: data, encoding: .utf8))
            XCTAssertEqual(
                jsonString,
                #"{"age":44,"name":"My Name"}"#
            )
        } catch let error as EncodingError {
            XCTFail(error.debugDescription)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    private static let encodingErrorSnippet = "Expected to encode String, found Int."
    
    /// Expects to encounter EncodingError and expects `error.debugDescription` to contain a certian substring.
    func testEncodingError() throws {
        class MyClass: BaseClass {
            override func encode(to encoder: any Encoder) throws {
                throw EncodingError.invalidValue(
                    "NyName" as Any,
                    EncodingError.Context(
                        codingPath: [CodingKeys.name] as [any CodingKey],
                        debugDescription: EncodingErrorUnitTests.encodingErrorSnippet
                    )
                )
            }
        }
        
        let instance = MyClass(
            name: "My Name",
            age: 44
        )
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        do {
            _ = try encoder.encode(instance)
            XCTFail("Expectd EncodingError")
        } catch let error as EncodingError {
            print(error.debugDescription)
            // EncodingError
            // error: The data couldn’t be written because it isn’t in the correct format.
            // subject: invalidValue: SomeValue
            // context: Expected to encode String, found Int.
            XCTAssertTrue(error.debugDescription.contains(EncodingErrorUnitTests.encodingErrorSnippet))
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
