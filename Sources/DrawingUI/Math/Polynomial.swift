//
//  Polynomial.swift
//  Polynomial
//
//  Created by Zakk Hoyt on 9/8/21.
//

import CoreGraphics
import Foundation

struct Polynomial: Identifiable, Hashable, CustomStringConvertible {
    static func == (lhs: Polynomial, rhs: Polynomial) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: String { description }
    
    private(set) var terms: [Term]

    init() {
        self.terms = [Polynomial.Term()]
    }

    init(term: Term) {
        self.terms = [term]
    }

    init(terms: [Term]) {
        self.terms = terms
    }

    var description: String {
        terms
            .map(\.description)
            .joined(separator: " + ")
    }

    func solve(_ v: CGFloat) -> CGFloat {
        terms.reduce(0) {
            switch $1.sign {
            case "+",
                 "-":
                $0 + $1.solve(v: v)
            default:
                preconditionFailure("Unsupported sign")
            }
        }
    }

    func solve(point: CGPoint) -> CGPoint {
        CGPoint(
            x: solve(point.x),
            y: solve(point.y)
        )
    }

    func derivative() -> Polynomial {
        Polynomial(
            terms: terms.map {
                let derivedExponenet = $0.exponent - 1
                return Term(
                    coefficient: $0.coefficient * $0.exponent,
                    variable: $0.variable,
                    exponent: derivedExponenet
                )
            }
        )
    }

    func stripTermsWithNegativeExponents() -> Polynomial {
        Polynomial(
            terms: terms.filter { $0.exponent >= 0 }
        )
    }

    func sortedTerms() -> Polynomial {
        Polynomial.sorted(polynomial: self)
    }

    func paddedTerms() -> Polynomial {
        Polynomial.padded(polynomial: self)
    }

    func reduceTerms() -> Polynomial {
        Polynomial.reduceTerms(polynomial: self)
    }
}

extension Polynomial {
    static func sorted(polynomial: Polynomial) -> Polynomial {
        Polynomial(
            terms: polynomial.terms.sorted { $0.exponent > $1.exponent }
        )
    }

    static func padded(polynomial: Polynomial) -> Polynomial {
        guard let maxExponent = (polynomial.terms.max { $0.exponent > $1.exponent })?.exponent else {
            return polynomial
        }
        guard let maxExponentTerm = (polynomial.terms.first { $0.exponent == maxExponent }) else {
            return polynomial
        }

        var terms = polynomial.terms
        for exponent in stride(from: maxExponent - 1, through: 0, by: -1) {
            guard !polynomial.terms.contains(where: { $0.exponent == exponent }) else {
                continue
            }
            terms.append(
                Term(
                    coefficient: 0,
                    variable: maxExponentTerm.variable,
                    exponent: exponent
                )
            )
        }

        return Polynomial(
            terms: terms
        )
    }

    static func reduceTerms(polynomial: Polynomial) -> Polynomial {
        var outputTerms: [Term] = []
        for term in polynomial.terms {
            if let index = (outputTerms.firstIndex { $0.variable == term.variable && $0.exponent == term.exponent }) {
                let exitingTerm = outputTerms[index]
                // Add to it and put it back in
                let sumTerm = Polynomial.addTerms(exitingTerm, term)
                outputTerms.remove(at: index)
                outputTerms.insert(sumTerm, at: index)
            } else {
                outputTerms.append(term)
            }
        }
        return Polynomial(terms: outputTerms)
    }
}

extension Polynomial {
    private static func addTerms(
        _ lhsTerm: Polynomial.Term,
        _ rhsTerm: Polynomial.Term
    ) -> Polynomial.Term {
        assert(lhsTerm.variable == rhsTerm.variable)
        assert(lhsTerm.exponent == rhsTerm.exponent)
        return Polynomial.Term(
            coefficient: lhsTerm.coefficient + rhsTerm.coefficient,
            variable: lhsTerm.variable,
            exponent: lhsTerm.exponent
        )
    }

    static func + (lhs: Polynomial, rhs: Polynomial) -> Polynomial {
        var outputTerms: [Term] = []

        let lhsReduced = Polynomial.reduceTerms(polynomial: lhs)
        for lhsTerm in lhsReduced.terms {
            if let index = (outputTerms.firstIndex { $0.variable == lhsTerm.variable && $0.exponent == lhsTerm.exponent }) {
                let exitingTerm = outputTerms[index]
                // Add to it and put it back in
                let sumTerm = addTerms(exitingTerm, lhsTerm)
                outputTerms.remove(at: index)
                outputTerms.insert(sumTerm, at: index)
            } else {
                outputTerms.append(lhsTerm)
            }
        }

        let rhsReduced = Polynomial.reduceTerms(polynomial: rhs)
        for rhsTerm in rhsReduced.terms {
            if let index = (outputTerms.firstIndex { $0.variable == rhsTerm.variable && $0.exponent == rhsTerm.exponent }) {
                let exitingTerm = outputTerms[index]
                // Add to it and put it back in
                let sumTerm = addTerms(exitingTerm, rhsTerm)
                outputTerms.remove(at: index)
                outputTerms.insert(sumTerm, at: index)
            } else {
                outputTerms.append(rhsTerm)
            }
        }
        return Polynomial(terms: outputTerms)
    }

    private static func subtractTerms(
        _ lhsTerm: Polynomial.Term,
        _ rhsTerm: Polynomial.Term
    ) -> Polynomial.Term {
        assert(lhsTerm.variable == rhsTerm.variable)
        assert(lhsTerm.exponent == rhsTerm.exponent)
        return Polynomial.Term(
            coefficient: lhsTerm.coefficient - rhsTerm.coefficient,
            variable: lhsTerm.variable,
            exponent: lhsTerm.exponent
        )
    }

    static func - (lhs: Polynomial, rhs: Polynomial) -> Polynomial {
        var outputTerms: [Term] = []

        let lhsReduced = Polynomial.reduceTerms(polynomial: lhs)
        for lhsTerm in lhsReduced.terms {
            if let index = (outputTerms.firstIndex { $0.variable == lhsTerm.variable && $0.exponent == lhsTerm.exponent }) {
                let exitingTerm = outputTerms[index]
                // Add to it and put it back in
                let diffTerms = addTerms(exitingTerm, lhsTerm)
                outputTerms.remove(at: index)
                outputTerms.insert(diffTerms, at: index)
            } else {
                outputTerms.append(lhsTerm)
            }
        }

        let rhsReduced = Polynomial.reduceTerms(polynomial: rhs)
        for rhsTerm in rhsReduced.terms {
            if let index = (outputTerms.firstIndex { $0.variable == rhsTerm.variable && $0.exponent == rhsTerm.exponent }) {
                let exitingTerm = outputTerms[index]
                // Add to it and put it back in
                let diffTerm = subtractTerms(exitingTerm, rhsTerm)
                outputTerms.remove(at: index)
                outputTerms.insert(diffTerm, at: index)
            } else {
                outputTerms.append(rhsTerm)
            }
        }
        return Polynomial(terms: outputTerms)
    }

    private static func multiplyTerms(
        _ lhsTerm: Polynomial.Term,
        _ rhsTerm: Polynomial.Term
    ) -> Polynomial.Term {
        assert(lhsTerm.variable == rhsTerm.variable)
        // (2*x) * (2*x) = 4 * x^2
        // (2*x) * (4*x) = 8 * x^2
        // (2*x) * (2*y) = 4 * x * y
        // (2*x) * (4*y) = 8 * x * y
        return Polynomial.Term(
            coefficient: lhsTerm.coefficient * rhsTerm.coefficient,
            variable: lhsTerm.variable,
            exponent: lhsTerm.exponent + rhsTerm.exponent
        )
    }

    static func * (lhs: Polynomial, rhs: Polynomial) -> Polynomial {
        var outputTerms: [Term] = []

        let lhsReduced = Polynomial.reduceTerms(polynomial: lhs)
        let rhsReduced = Polynomial.reduceTerms(polynomial: rhs)
        for l in 0..<lhsReduced.terms.count {
            let lhsTerm = lhsReduced.terms[l]
            for r in 0..<rhsReduced.terms.count {
                let rhsTerm = rhsReduced.terms[r]
                let multiplyTerm = multiplyTerms(lhsTerm, rhsTerm)
                outputTerms.append(multiplyTerm)
            }
        }

        let polynomial = Polynomial(
            terms: outputTerms
        )
        return Polynomial.reduceTerms(
            polynomial: polynomial
        )
    }

    static func power(lhs: Polynomial, exponent: Int) -> Polynomial {
        if exponent == 0 {
//            return Polynomial(
//                terms: lhs.terms.map { term in
//                    Term(
//                        coefficient: term.coefficient,
//                        variable: term.variable,
//                        exponent: 0
//                    )
//                }
//            )
            guard let firstTerm = lhs.terms.first else {
                preconditionFailure("TODO: Implement this case")
            }
            return Polynomial(
                term: Term(
                    coefficient: 1,
                    variable: firstTerm.variable,
                    exponent: 0
                )
            )
        } else if exponent < 0 {
            preconditionFailure("TODO: Implement this case")
        } else {
            let lhsReduced = Polynomial.reduceTerms(polynomial: lhs)
            let upperBound = max(exponent - 1, 0)
            return (0..<upperBound).reduce(lhsReduced) { result, _ in
                result * lhsReduced
            }
        }
    }
}

extension [Polynomial] {
    func joined() -> Polynomial {
        reduce(Polynomial()) { // result, poly in
            $0 + $1
        }
    }
}

extension Polynomial {
    struct Term: CustomStringConvertible {
        let coefficient: Int
        // TODO: Make this array of chars
        let variable: String
        let exponent: Int
        
        init() {
            self.coefficient = 0
            self.variable = "t"
            self.exponent = 0
        }
        
        init(
            coefficient: Int,
            variable: String,
            exponent: Int
        ) {
            self.coefficient = coefficient
            self.variable = variable
            self.exponent = exponent
        }
        
        var sign: String {
            coefficient < 0 ? "-" : "+"
        }
        
        var description: String {
            [
                "\(coefficient)",
                "\(variable)^\(exponent)"
            ]
                .compactMap { $0 }
                .joined(separator: "*")
        }
        
        func solve(v: CGFloat) -> CGFloat {
            CGFloat(coefficient) * pow(v, CGFloat(exponent))
        }
    }
}
