//
//  Bezier+Polynomial.swift
//  Bezier+Polynomial
//
//  Created by Zakk Hoyt on 9/9/21.
//
//  https://pomax.github.io/bezierinfo/#explanation

import CoreGraphics
import Foundation

extension Bezier {
    /// Creates an array of polynomials which together represent a bezier curve in Bernstein Polynomial Form.
    ///
    /// The coefficients come from a Pascal's Triangle.
    /// Great paper [here](https://pomax.github.io/bezierinfo/#explanation)
    /// See section #7 and #35
    ///
    /// - Parameter order: The order of the polynomial (highest exponent)
    /// - Returns: A `Polynomial` instance.
    /// - SeeAlso: ``Bezier/basisFunctions(order:)``
    ///
    /// ```
    /// B(t) = p_0 * 1 * (1 - t)^3 * t^0
    ///      + p_1 * 3 * (1 - t)^2 * t^1
    ///      + p_2 * 3 * (1 - t)^1 * t^2
    ///      + p_3 * 1 * (1 - t)^0 * t^3
    /// ```
    ///
    /// Disregarding our actual coordinates for a moment, we have:
    /// ```
    /// B(t) = 1 * (1 - t)^3 * t^0
    ///      + 3 * (1 - t)^2 * t^1
    ///      + 3 * (1 - t)^1 * t^2
    ///      + 1 * (1 - t)^0 * t^3
    /// ```
    ///
    /// We can rewrite this as:
    /// ```
    /// B(t) =     (1 - t)^3
    ///      + 3 * (1 - t)^2 * t
    ///      + 3 * (1 - t)   * t^2
    ///      +                 t^3
    /// ```
    ///
    /// And we can expand these expressions:
    /// ```
    /// B(t) = (1 - t) * (1 - t) * (1 - t)
    ///      + 3 * (1 - t) * (1 - t) * t
    ///      + 3 * (1 - t) * t * t
    ///      + t * t * t
    /// ```
    ///
    /// which can be rewritten as (using [wolfram alpha](https://www.mathportal.org/calculators/polynomials-solvers/polynomials-expanding-calculator.php))
    /// ```
    /// B(t) = -1 * t^3 + 3 * t^2 - 3 * t^1 + 1 * t^0
    ///      + 3 * t^3 - 6 * t^2 + 3 * t^1 + 0 * t+0
    ///      + -3 * t^3 + 3 * t^2 + 0 * t^1 + 0 * t^0
    ///      + 1 * t^3 + 0 * t^2 + 0 * t^1 + 0 * t^0
    /// ```
    static func basisFunctions(order: Int) -> [Polynomial] {
        let pascal = PascalTriangle(order: order)
        let coefficients = pascal.values[pascal.values.count - 1]
        return coefficients.enumerated().map { iter in
            Polynomial(term: Polynomial.Term(coefficient: iter.element, variable: "t", exponent: 0))
                * Polynomial.power(
                    lhs: Polynomial(terms: [
                        Polynomial.Term(coefficient: 1, variable: "t", exponent: 0),
                        Polynomial.Term(coefficient: -1, variable: "t", exponent: 1)
                    ]),
                    exponent: order - iter.offset
                )
                * Polynomial(term: Polynomial.Term(coefficient: 1, variable: "t", exponent: iter.offset))
                .sortedTerms()
                .paddedTerms()
        }
    }
    
    /// Creates a polynomial which represents a bezier in Bernstein Polynomial Form.
    ///
    /// The coefficients come from a Pascal's Triangle.
    /// Great paper [here](https://pomax.github.io/bezierinfo/#explanation)
    /// See section #7 and #35
    ///
    /// - Parameter order: The order of the polynomial (highest exponent)
    /// - Returns: A `Polynomial` instance.
    static func basisFunction(order: Int) -> Polynomial {
        let pascal = PascalTriangle(order: order)
        let coefficients = pascal.values[pascal.values.count - 1]
        return Polynomial(
            terms: coefficients.enumerated().map {
                Polynomial.Term(
                    coefficient: $0.element,
                    variable: "t",
                    exponent: order - $0.offset
                )
            }
        )
    }
}
