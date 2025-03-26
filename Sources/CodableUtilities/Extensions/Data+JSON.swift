//
//  Data+JSON.swift
//
//  Created by Zakk Hoyt on 3/24/25.
//  Copyright hatch.co, 2025.
//

import Foundation

extension Data {
    public var jsonString: String? {
        utf8String
    }

    public var utf8String: String? {
        guard let str = String(data: self, encoding: .utf8) else {
            return nil
        }
        return str
    }

    public var deserializedJSONString: String? {
        if let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []),
           let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
           let prettyString = String(data: prettyData, encoding: .utf8) {
            return prettyString
        } else {
            print("Failed to convert Data to JSON.")
            return nil
        }
    }
}
