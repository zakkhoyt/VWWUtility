//
//  Bezier.swift
//  Mathic
//
//  Created by Zakk Hoyt on 5/22/20.
//  Copyright © 2020 Zakk Hoyt. All rights reserved.
//
//  https://en.wikipedia.org/wiki/B%C3%A9zier_curve
//  https://medium.com/@Acegikmo/the-ever-so-lovely-b%C3%A9zier-curve-eb27514da3bf
//  UICubicTimingParameters
// @available(iOS 10.0, *)
// open class UICubicTimingParameters : NSObject, UITimingCurveProvider {

import CoreGraphics
import Foundation

enum Bezier {
    static let defaultControlPoints = [
        CGPoint(x: 0, y: 1),
        CGPoint(x: 0, y: 0),
        CGPoint(x: 1, y: 1),
        CGPoint(x: 1, y: 0)
//        ,
//        CGPoint(x: 0.75, y: 0.25)
    ]

//    private static var d_minX: CGFloat = 100
//    private static var d_maxX: CGFloat = -100
//    private static var d_minY: CGFloat = 100
//    private static var d_maxY: CGFloat = -100

    /// Solves for a point on a bezier curve.
    /// - Parameters:
    ///   - points: The control points in normalized range 0...1.
    ///   - t: Time from 0...1
    /// - Throws: Errors if any points or 1 is out of bounds.
    /// - Returns: tuple. .0 is a point along the bezier curve where x/y in 0...1), .1 and .2 are the start/end points of the tangent line (derivative)
    /// - Returns: An instance of `Bezier.Solution`
    static func solve(
        points controlPoints: [CGPoint],
        t: CGFloat
    ) throws -> Solution {
        let range: ClosedRange<CGFloat> = CGFloat(0.0)...CGFloat(1.0)

        guard range.contains(t) else {
            throw Bezier.Solution.Error.inputOutOfRange(t: t)
        }

        for point in controlPoints {
            if !range.contains(point.x) || !range.contains(point.y) {
                throw Bezier.Solution.Error.pointOutOfRange(point: point)
            }
        }

        /// Recursively solves a bezier curve based on `controlPoints` and `t` (using De casteljau's algorithm aka lerping).
        /// - Parameters:
        ///   - points: The control handles where x and y are all in range `0.0 ... 1.0`
        ///   - t: T value 0.0 ... 1.0
        /// - Returns: Returns a `Bezier.Solution` instance
        func reduce(
            points: [[CGPoint]],
            t: CGFloat
        ) -> Solution {
            let deezPoints = points[points.count - 1]
            var nextPoints: [CGPoint] = []
            for i in 0..<deezPoints.count {
                if i == 0 {
                    continue
                }
                let point0 = deezPoints[i - 1]
                let point1 = deezPoints[i]
                let point = CGPoint.interpolate(percent: t, point0: point0, point1: point1)
                if deezPoints.count == 2 {
                    let polynomials = Bezier.basisFunctions(order: controlPoints.count - 1)
                        .map { $0.derivative() }
                        .map { $0.stripTermsWithNegativeExponents() }

                    let finalPoint: CGPoint = {
                        // FIXME: @zakkhoyt - Covert this processInfo to a function parameter
                        if ProcessInfo.processInfo.arguments.contains("drawDerivative") {
                            // TODO: @zakkhoyt - Document this function. Not sure what it's doing now.
                            let polyPoint = Bezier.solveForPoint(
                                polynomials: polynomials,
                                t: t,
                                controlPoints: controlPoints
                            )
                            assert(!polyPoint.x.isNaN && !polyPoint.y.isNaN, "polyPoint.x.isNaN || polyPoint.y.isNaN ")

//                            let scale: CGFloat = 0.1
//                            let x = polyPoint.x * scale
//                            let y = polyPoint.y * -scale

                            // TODO: Whey do we need these scale factors? Do we?
                            let x = polyPoint.x / 1.5
                            let y = polyPoint.y / -3

                            //                    d_minX = min(d_minX, x)
                            //                    d_maxX = max(d_maxX, x)
                            //                    d_minY = min(d_minY, y)
                            //                    d_maxY = max(d_maxY, y)
                            //                    print("d_minX: \(d_minX) x: \(polyPoint.x) d_maxX: \(d_maxX) d_minY: \(d_minY) y: \(polyPoint.y) d_maxY: \(d_maxY)")
                            //                     d_minX: 0.0016819527865630235
                            //                     d_maxX: 1.4999995316046775
                            //                     d_minY: -2.996636094426875
                            //                     d_maxY: -0.0000009367906450563623e-07

                            return CGPoint(
                                x: x,
                                y: y
                            )
                        } else {
                            return point
                        }
                    }()

                    var pointsPyramid = points
                    pointsPyramid.append([finalPoint])
                    return Solution(
                        t: t,
                        tangentLine: Line(point0: point0, point1: point1),
                        pointsPyramid: pointsPyramid,
                        polynomials: polynomials
                    )
                } else {
                    nextPoints.append(point)
                }
            }

            var pointsPyramid = points
            pointsPyramid.append(nextPoints)
            return reduce(points: pointsPyramid, t: t)
        }

        return reduce(points: [controlPoints], t: t)
    }
}

extension Bezier {
    static func solveForPoint(
        polynomials: [Polynomial],
        t: CGFloat,
        controlPoints: [CGPoint]
    ) -> CGPoint {
        guard controlPoints.count == polynomials.count else {
            let message = "controlPoints.count \(controlPoints.count) != polynomials.count \(polynomials.count)"
            preconditionFailure(message)
        }

        return controlPoints
            .enumerated()
            .map { iter in
                let index = iter.offset
                let controlPoint = iter.element
                let polynomial = polynomials[index]
                let solution = polynomial.solve(t)
                if solution.isNaN {
                    print("solution.isNaN")
                }
                let point = solution * controlPoint
                return point
            }
            .reduce(.zero, +)
    }
}
