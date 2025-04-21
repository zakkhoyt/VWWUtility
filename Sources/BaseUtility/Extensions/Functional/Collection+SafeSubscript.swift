//
//  Collection+SafeSubscript.swift
//  Nightlight
//
//  Created by Alex Scharch on 5/19/21.
//  Copyright © 2021 Hatch. All rights reserved.
//

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    ///
    /// ## References
    ///
    /// * [Stack Overflow](https://stackoverflow.com/a/30593673/1516011)
    public subscript(safe index: Index) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
    
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    /// - Throws: If index is out of bounds `CollectionError.indexOutOfBounds`
    ///
    /// ## Example
    ///
    ///    let arr = [0, 1]
    /// ```swift
    ///    // Happy path
    ///    let a: Int = try arr[index: 0]
    ///    let b: Int? = try? arr[index: 1]
    ///    guard let c: Int = try? arr[index: 0] else { return }
    ///
    ///    // Throwing example
    ///    do {
    ///        let c = try arr[index: 99]
    ///    } catch let error as CollectionError.indexOutOfBounds {
    ///        // index out of bounds.
    ///    }
    /// ```
    public subscript(index index: Index) -> Element {
        get throws {
            guard let element = self[safe: index] else { throw CollectionError.indexOutOfBounds }
            return element
        }
    }
}

public enum CollectionError: Swift.Error {
    case indexOutOfBounds
}
