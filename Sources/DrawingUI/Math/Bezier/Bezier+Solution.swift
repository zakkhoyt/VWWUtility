//
// Bezier+Solution.swift
// Bezier+Solution
//
// Created by Zakk Hoyt on 9/8/21.
//

import CoreGraphics
import Foundation

extension Bezier {
    /// Containst the values for in input of T
    struct Solution {
        enum Error: Swift.Error, LocalizedError {
            case inputOutOfRange(t: CGFloat)
            case pointOutOfRange(point: CGPoint)

            var errorDescription: String? {
                switch self {
                case .inputOutOfRange(let t):
                    "Input out of range: \(t)"
                case .pointOutOfRange(let point):
                    "Point out of range: \(point.debugDescription)"
                }
            }
        }

        #warning("How do we want to include derivative, normal, tangent, etc..? A separate solution instance?")

        /// The 't' value from 0.0 ... 1.0
        let t: CGFloat

        /// The final point after all recursively solving until there are only 2 controlPoints
        var point: CGPoint {
            pointsPyramid.last?.last ?? .zero
        }

        /// Tangent line for input `t`
        let tangentLine: Line

        var tangent: CGFloat {
            tangentLine.angle
        }

        var normal0: CGFloat {
            tangent.normal0
        }
        
        var normal1: CGFloat {
            tangent.normal1
        }

        /// An array of arrays of cgpoints where:
        /// index 0 is all the controlPoints,
        /// index 1 has 1 fewer control points,
        /// index n-1 has 1 controlPoint which is the solution.
        /// EX: for t = 0.5
        /// [
        ///     [(0.000, 1.000), (0.000, 0.000), (1.000, 1.000), (1.000, 0.000)],
        ///     [(0.000, 0.500), (0.500, 0.500), (1.000, 0.500)],
        ///     [(0.250, 0.500), (0.750, 0.500)],
        ///     [(0.500, 0.500)]
        /// ]
        let pointsPyramid: [[CGPoint]]
        
        struct PointPyramidRow: Identifiable {
            var id: Int { index }
            let index: Int
            let points: [CGPoint]
        }
        
        var pointPyramidRows: [PointPyramidRow] {
            pointsPyramid.enumerated().map {
                PointPyramidRow(index: $0.offset, points: $0.element)
            }
        }

        let polynomials: [Polynomial]
    }
}

extension Bezier.Solution {
    static let empty = Bezier.Solution(
        t: 0,
        tangentLine: Line(point0: .zero, point1: .zero),
        pointsPyramid: [[]],
        polynomials: []
    )
}
    
extension Bezier.Solution: CustomDebugStringConvertible {
    var debugDescription: String {
        """
        [
        \(
            pointsPyramid.map { points in
                points.map { point in
                    "(\(String(format: "%.3f", point.x)), \(String(format: "%.3f", point.y)))"
                }
                .joined(separator: ", ")
            }
            .map { "[\($0)]" }
            .joined(separator: ",\n")
        )
        ]
        """
    }
}

extension Bezier.Solution {
    func normalLines(length: CGFloat) -> [Line] {
        let line0: Line = {
            let point0 = point
            let point1 = CGPoint(
                x: point0.x + length * cos(self.normal0),
                y: point0.y + length * sin(self.normal0)
            )
            return Line(point0: point0, point1: point1)
        }()
        
        let line1: Line = {
            let point0 = point
            let point1 = CGPoint(
                x: point0.x + length * cos(self.normal1),
                y: point0.y + length * sin(self.normal1)
            )
            return Line(point0: point0, point1: point1)
        }()
        return [line0, line1]
    }
}
