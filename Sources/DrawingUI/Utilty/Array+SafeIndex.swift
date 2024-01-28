//
//  Array+SafeIndex.swift
//  Array+PascalTriangle
//
//  Created by Zakk Hoyt on 9/9/21.
//

import Foundation

extension Array {
    var indexRange: Range<Int> { 0..<count }
}

extension [[Int]] {
    subscript(safeIndex index: Int) -> [Int]? {
        indexRange ~= index ? self[index] : nil
    }
}

extension [Int] {
    subscript(safeIndex index: Int) -> Int? {
        indexRange ~= index ? self[index] : nil
    }
}
