//
//  CGLine.swift
//  Bezier
//
//  Created by Zakk Hoyt on 9/6/21.
//

import CoreGraphics
import Foundation
 
public struct CGLine {
    public let point0: CGPoint
    public let point1: CGPoint

    public init(
        point0: CGPoint,
        point1: CGPoint
    ) {
        self.point0 = point0
        self.point1 = point1
    }
}

extension CGLine {
    public var deltaX: CGFloat {
        point1.x - point0.x
    }

    public var deltaY: CGFloat {
        point1.y - point0.y
    }
}

extension CGLine {
    /// - Returns: Angle (in radians) of a line between two points and in terms of 0 ... 2*CGFloat.pi
    public var angle: CGFloat {
        CGFloat.project(
            angle: atan2(
                point1.y - point0.y,
                point1.x - point0.x
            )
        )
    }

    /// - Returns: Self rotated by `.pi`, keeping in range `0 ... 2 * .pi`
    public var reverseAngle: CGFloat {
        CGFloat.project(angle: angle - .pi)
    }

    /// - Returns: Length of the line using pythagorean theorem
    public var length: CGFloat {
        sqrt(
            pow(abs(point0.x - point1.x), 2) +
                pow(abs(point0.y - point1.y), 2)
        )
    }
}

extension CGVector {
    var length: CGFloat {
        sqrt(pow(dx, 2) + pow(dy, 2))
    }
    
    /// `|a| × |b| × cos(θ)`
    ///
    /// OR we can calculate it this way:
    ///
    /// `a · b = ax × bx + ay × by`
    ///
    /// **SeeAlso:**
    ///
    /// [vectors-dot-product](https://www.mathsisfun.com/algebra/vectors-dot-product.html)
    ///
    func dotProduct(other: CGVector) -> CGFloat {
        dx * other.dx + dy * other.dy
    }
    
    /// This is used to project `self` onto another vector `other`.
    /// - Important: This function is only applicable to unit vectors.
    ///
    /// If result is near 1, unit vectors point in the same direction
    /// If resutl is near 0, unit vectors are perpindicular
    /// If result near -1, unit vectors point away from each other.
    func unitDotProduct(other: CGVector) -> CGFloat {
#if DEBUG
        assert(length == 1.0 && other.length == 1.0, "dotProduct only applicable to unitVectors")
#endif
        return dotProduct(other: other)
    }
    
//    /// https://www.mathsisfun.com/algebra/vectors-cross-product.html
//    func crossProduct(b: CGVector, c: CGVector) -> CGVector {
//
//    }
}
