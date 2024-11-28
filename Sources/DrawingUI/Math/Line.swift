//
//  Line.swift
//  Bezier
//
//  Created by Zakk Hoyt on 9/6/21.
//

import CoreGraphics
import Foundation

public struct Line: Identifiable {
    public var id: CGFloat {
        point0.x + point0.y + point1.x + point1.y
    }
    
    /// An alternative to our `id` property which can certainly have duplicates.
    public var uuid: UUID {
        UUID()
    }
    
    public let point0: CGPoint
    public let point1: CGPoint

    public init(
        point0: CGPoint,
        point1: CGPoint
    ) {
        self.point0 = point0
        self.point1 = point1
    }

    public init(
        x0: CGFloat,
        y0: CGFloat,
        x1: CGFloat,
        y1: CGFloat
    ) {
        self.point0 = CGPoint(x: x0, y: y0)
        self.point1 = CGPoint(x: x1, y: y1)
    }
}

extension Line {
    public var deltaX: CGFloat {
        point1.x - point0.x
    }

    public var deltaY: CGFloat {
        point1.y - point0.y
    }
}

extension Line {
    /// - Returns: Angle (in radians) of a line between two points and in terms of 0 ... .tau
    public var angle: CGFloat {
        .modulo(
            angle: atan2(
                point1.y - point0.y,
                point1.x - point0.x
            )
        )
    }

    public var reverseAngle: CGFloat {
        .modulo(angle: angle - .pi)
    }

    /// - Returns: Length of the line using pythagorean theorem
    public var length: CGFloat {
        sqrt(
            pow(abs(point0.x - point1.x), 2) +
                pow(abs(point0.y - point1.y), 2)
        )
    }
}

