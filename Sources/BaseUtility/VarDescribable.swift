//
//  File.swift
//  
//
//  Created by Zakk Hoyt on 12/5/23.
//

import Collections
import Foundation

extension [String: String?] {
    public var varDescription: String {
        OrderedDictionary<String, String>(
            self.compactMapValues { $0 }
        ).map {
            [
                $0.key, $0.value
            ].joined(separator: ": ")
        }.joined(separator: ", ")

    }
}
