//
//  Dictionary+Helpers.swift
//
//  Created by Scott Marchant on 8/4/22.
//

import Foundation

extension [AnyHashable: Any] {
    /// Flattens nested `[AnyHashable: Any]` returning the path where values
    /// are a primitive (not another `[AnyHashable: Any]`).
    public func extractLeafKeypaths() -> [String] {
        var output = Set<String>()
        
        func extract(path: String, dictionary: [AnyHashable: Any]) {
            for (key, value) in dictionary {
                let currentPath = "\(path).\(key)"
                if let dictionary = value as? [AnyHashable: Any] {
                    extract(path: currentPath, dictionary: dictionary)
                } else {
                    output.insert(currentPath)
                }
            }
        }
        extract(path: "", dictionary: self)
        
        return Array(output)
    }
}

extension Dictionary where Key: Comparable, Value: Equatable {
    public func minus(dict: [Key: Value]) -> [Key: Value] {
        let entriesInSelfAndNotInDict = filter { dict[$0.0] != self[$0.0] }
        return entriesInSelfAndNotInDict.reduce([Key: Value]()) { res, entry -> [Key: Value] in
            var res = res
            res[entry.0] = entry.1
            return res
        }
    }
    
    public func difference(other: [Key: Value]) -> [Key: Value] {
        var output: [Key: Value] = [:]
        for (key, value) in other {
            if let otherValue = other[key], otherValue == value {
            } else {
                output[key] = value
            }
        }
        return output
    }
}
