//
//  Array+Helper.swift
//
//  Created by Zakk Hoyt on 6/23/23.
//

import Collections
import Foundation

extension Dictionary {
    public var orderedDictionary: OrderedDictionary<Key, Value> {
        OrderedDictionary(dictionary: self)
    }
}

extension OrderedDictionary {
    public init(dictionary: Dictionary<Key, Value>) {
        self.init(uniqueKeys: dictionary.keys, values: dictionary.values)
    }
    
    public init(_ dictionary: Dictionary<Key, Value>) {
        self.init(uniqueKeys: dictionary.keys, values: dictionary.values)
    }
}


extension OrderedDictionary {
    public var dictionary: Dictionary<Key, Value> {
        Dictionary(orderedDictionary: self)
    }
}

extension Dictionary {
    public init(orderedDictionary: OrderedDictionary<Key, Value>) {
        self.init(
            uniqueKeysWithValues: orderedDictionary.reduce(into: []) {
                $0.append(($1.key, $1.value))
            }
        )
    }
}
