//
//  CGPoint+Helpers.swift
//  Mathic
//
//  Created by Zakk Hoyt on 5/2/20.
//  Copyright © 2020 Zakk Hoyt. All rights reserved.
//

import CoreGraphics

extension CGPoint {
    public static let unit = CGPoint(x: 1, y: 1)
}


extension CGPoint {
    /// Returns a `CGPoint` where `x` and `y` are
    /// mapped to normalized range (`0.0 ... 1.0`)
    public func contract(
        size: CGSize
    ) -> CGPoint {
        CGPoint(
            x: x.contract(max: size.width),
            y: y.contract(max: size.height)
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
    public func invertY(
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

extension CGPoint {
    public static func - (lhs: CGPoint, rhs: CGSize) -> CGPoint {
        CGPoint(
            x: lhs.x - rhs.width,
            y: lhs.y - rhs.height
        )
    }
}



extension CGPoint {
    public static func * (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(
            x: lhs.x * rhs.x,
            y: lhs.y * rhs.y
        )
    }

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
    public enum Transform {
        public enum Scale {
            public static let mirrorX = CGPoint(x: -1, y: 1)
            public static let mirrorY = CGPoint(x: 1, y: -1)
            public static let mirrorXY = CGPoint(x: -1, y: -1)
        }
    }

    public var mirrorX: CGPoint {
        self * Transform.Scale.mirrorX
    }

    public var mirrorY: CGPoint {
        self * Transform.Scale.mirrorY
    }
    
    public var mirrorXY: CGPoint {
        self * Transform.Scale.mirrorXY
    }
}


//public protocol PointRepresentable {
//    var x: Double { get }
//    var y: Double { get }
//    
//    init()
//    
//    init(x: Double, y: Double)
//}
//
//
//extension PointRepresentable {
//    public static var zero: Self {
//        self.init()
//    }
//
//    public init() {
//        self.init(x: 0, y: 0)
//    }
//    
//    init(x: Double, y: Double) {
//        self.init(x: x, y: y)
//    }
//    
//    public var cgPoint: CGPoint {
//        CGPoint(x: x, y: y)
//    }
//    
//    public static func from(cgPoint: CGPoint) -> Self {
//        self.init(x: cgPoint.x, y: cgPoint.y)
//    }
//}
//
//public struct NormalPoint: PointRepresentable {
//    public let x: Double
//    public let y: Double
//    
//    public init(
//        x: Double,
//        y: Double
//    ) {
//        self.x = x
//        self.y = y
//    }
//}
