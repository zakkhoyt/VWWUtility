//
//  CGPoint+Helpers.swift
//  Mathic
//
//  Created by Zakk Hoyt on 5/2/20.
//  Copyright © 2020 Zakk Hoyt. All rights reserved.
//

import CoreGraphics


extension CGPoint {
    /// Returns a `CGPoint` where `x` and `y` are
    /// mapped to normalized range (`0.0 ... 1.0`)
    public func contract(
        size: CGSize
    ) -> CGPoint {
        CGPoint(
            x: x.percent(of: size.width),
            y: y.percent(of: size.height)
        )
    }

    /// Returns a normalized `CGPoint` where `x` and `y` are
    /// mapped from normalized range (`0.0 ... 1.0`) to `size`.
    public func expand(
        size: CGSize
    ) -> CGPoint {
        CGPoint(
            x: x * size.width,
            y: y * size.height
        )
    }
}

extension CGPoint {
    public func reflectY(
        size: CGSize
    ) -> CGPoint {
        CGPoint(
            x: x,
            y: size.height - y
        )
    }
}

extension CGFloat {
    // TODO: For what ever reason, I can't use max/min here.
    // Compile errors
    public func clip(to size: CGSize) -> CGFloat {
        if self < 0 {
            0
        } else if self > size.width {
            size.width
        } else {
            self
        }
    }
}

extension CGPoint {
    public static func interpolate(
        percent: CGFloat,
        point0: CGPoint,
        point1: CGPoint
    ) -> CGPoint {
        CGPoint(
            x: .interpolate(percent: percent, lower: point0.x, upper: point1.x),
            y: .interpolate(percent: percent, lower: point0.y, upper: point1.y)
        )
    }
}

extension CGPoint {
    public func offset(dx: CGFloat = 0, dy: CGFloat = 0) -> CGPoint {
        CGPoint(x: x + dx, y: y + dy)
    }

    public func add(point: CGPoint) -> CGPoint {
        CGPoint(x: x + point.x, y: y + point.y)
    }

    public static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

extension CGPoint {
    public func clip(to rect: CGRect) -> CGPoint {
        CGPoint(
            x: min(max(rect.origin.x, x), rect.origin.x + rect.size.width),
            y: min(max(rect.origin.y, y), rect.origin.y + rect.size.height)
        )
    }

    public func clip(to size: CGSize) -> CGPoint {
        CGPoint(
            x: min(max(0, x), 0 + size.width),
            y: min(max(0, y), 0 + size.height)
        )
    }
}

extension CGSize {
    public static func * (lhs: CGSize, rhs: CGFloat) -> CGPoint {
        CGPoint(
            x: lhs.width * rhs,
            y: lhs.height * rhs
        )
    }

    public static func / (lhs: CGSize, rhs: CGFloat) -> CGPoint {
        CGPoint(
            x: lhs.width / rhs,
            y: lhs.height / rhs
        )
    }
}

extension CGPoint {
    public static func - (lhs: CGPoint, rhs: CGSize) -> CGPoint {
        CGPoint(
            x: lhs.x - rhs.width,
            y: lhs.y - rhs.height
        )
    }
}

extension CGFloat {
    /// Adds or subtracts `2*pi` until  range `lowerBound ..< upperBound` contains `angle`.
    /// - Parameter angle: Input angle
    /// - Parameter into: The range to project `angle` in to.
    /// - Returns: Output angle in the range `0 ..< 2*CGFloat.pi`
    public static func project(
        angle: CGFloat,
        into range: Range<CGFloat> = (0 * CGFloat.pi)..<(2 * CGFloat.pi)
    ) -> CGFloat {
        let delta = range.upperBound - range.lowerBound

        // A recursive function to move the angle within a certain range
        func adjust(angle: CGFloat) -> CGFloat {
            if angle < range.lowerBound {
                adjust(angle: angle + delta)
            } else if angle >= range.upperBound {
                adjust(angle: angle - delta)
            } else {
                angle
            }
        }
        return adjust(angle: angle)
    }

    /// Returns angle (in radians) of a line between two points
    /// - Parameters:
    ///   - point0: first point in a line
    ///   - point1: second point in a line
    /// - Returns: Angle (in radians) of a line between two points and in terms of 0 ... 2*CGFloat.pi
    public static func angle(point0: CGPoint, point1: CGPoint) -> CGFloat {
        CGFloat.project(
            angle: atan2(
                point1.y - point0.y,
                point1.x - point0.x
            )
        )
    }

    /// given that self is an angle in radians, normal is that `self + 1 / 2 * CGFloat.pi` in terms of `0 ..< 2 * CGFloat.pi`
    public var normal0: CGFloat {
        CGFloat.project(
            angle: CGFloat.project(angle: self + 1 / 2 * CGFloat.pi)
        )
    }
    
    public var normal1: CGFloat {
        CGFloat.project(
            angle: CGFloat.project(angle: self - 1 / 2 * CGFloat.pi)
        )
    }
}

extension CGPoint {
    public static func * (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        CGPoint(
            x: lhs.x * rhs,
            y: lhs.y * rhs
        )
    }

    public static func * (lhs: CGFloat, rhs: CGPoint) -> CGPoint {
        CGPoint(
            x: lhs * rhs.x,
            y: lhs * rhs.y
        )
    }
}

extension CGPoint {
    public var invertY: CGPoint {
        CGPoint(x: x, y: -y)
    }
}
