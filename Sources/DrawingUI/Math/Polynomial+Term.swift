//
//  Polynomial+Term.swift
//  Bezier
//
//  Created by Zakk Hoyt on 9/10/21.
//

import CoreGraphics
import Foundation

extension Polynomial {
    public struct Term: CustomStringConvertible {
        let coefficient: Int
        // TODO: Make this array of chars
        let variable: String
        let exponent: Int

        public init() {
            self.coefficient = 0
            self.variable = "t"
            self.exponent = 0
        }

        public init(
            coefficient: Int,
            variable: String,
            exponent: Int
        ) {
            self.coefficient = coefficient
            self.variable = variable
            self.exponent = exponent
        }

        public var sign: String {
            coefficient < 0 ? "-" : "+"
        }

        public var description: String {
            [
                "\(coefficient)",
                "\(variable)^\(exponent)"
            ]
                .compactMap { $0 }
                .joined(separator: "*")
        }

        public func solve(v: CGFloat) -> CGFloat {
            CGFloat(coefficient) * pow(v, CGFloat(exponent))
        }
    }
}
