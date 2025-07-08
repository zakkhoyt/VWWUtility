//
//  AsyncArray.swift
//
//  Created by Zakk Hoyt on 6/23/23.
//

import Foundation

public struct AsyncArray<T>: AsyncSequence, AsyncIteratorProtocol {
    public typealias Element = T

    public let items: [T]
    private var index = 0
    
    public init(items: [T]) {
        self.items = items
    }

    public mutating func next() async -> T? {
        guard !Task.isCancelled else {
            return nil
        }

        guard index < items.count else {
            return nil
        }

        let result = items[index]
        index += 1
        return result
    }

    public func makeAsyncIterator() -> Self {
        self
    }
}

