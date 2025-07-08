//
//  Array+Functional.swift
//
//  Created by Dan Sandland on 11/20/24.
//  Copyright hatch.co, 2024.
//

extension Array {
    public func dropLastWhile(_ predicate: (Element) -> Bool) -> Array {
        var idx = endIndex
        while idx != startIndex, predicate(self[index(before: idx)]) {
            idx = index(before: idx)
        }
        return Array(self[..<idx])
    }
}
