//
//  Bezier+Matrix.swift
//  Bezier
//
//  Created by Zakk Hoyt on 9/12/21.
//

import CoreGraphics
import Foundation

extension Bezier {
    enum Matrix {
        // https://pomax.github.io/bezierinfo/#explanation
        // Secction 7
        //
        // func tMatrix(order, t) -> [CGFloat]
        // | t^0 t^1 t^2 t^3 |
        //
        // func coefficientsMatrix(order) -> [[CGFloat]]
        // |  1   0   0   0  |
        // | -3   3   0   0  |
        // |  3  -6   3   0  |
        // |  -1  3  -3   1  |
        //
        // func controlPointsMatrix([CGPoint]) -> [CGPoint]
        // | P0 |
        // | P1 |
        // | P2 |
        // | P3 |

        static func tExponent(order: Int) -> [CGFloat] {
            []
        }

        static func tExponent(order: Int) -> [Polynomial.Term] {
            []
        }

        static func coefficient(order: Int) -> [[CGFloat]] {
            [[]]
        }

        static func controlPoint(order: Int) -> [CGFloat] {
            []
        }
    }
}
