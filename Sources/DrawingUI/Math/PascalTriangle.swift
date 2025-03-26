//
// PascalTriangle.swift
// PascalTriangle
//
// Created by Zakk Hoyt on 9/9/21.
//

import Foundation

struct PascalTriangle {
    let values: [[Int]]

    ///                 [1],            y=0
    ///                [1,1],           y=1
    ///               [1,2,1],          y=2
    ///              [1,3,3,1],         y=3
    ///             [1,4,6,4,1],        y=4
    ///            [1,5,10,10,5,1],     y=5
    ///           [1,6,15,20,15,6,1]]   y=6
    init(order: Int) {
        self.values = (0...order).reduce([]) { // partialResult, <#Int#> in
            var triangle = $0
            let y = $1
            var row = [Int](repeating: 1, count: y + 1)

            if let previousRow = triangle[safeIndex: y - 1] {
                row = row.enumerated().map { iter in
                    guard let previousLeft = previousRow[safeIndex: iter.offset - 1],
                          let previousRight = previousRow[safeIndex: iter.offset] else {
                        return iter.element
                    }
                    return previousLeft + previousRight
                }
            }

            triangle.append(row)
            return triangle
        }
    }
}

extension PascalTriangle: CustomStringConvertible {
    var description: String {
        values.map { row in
            row.map { "\($0)" }.joined(separator: ", ")
        }
        .joined(separator: "\n")
    }
}
