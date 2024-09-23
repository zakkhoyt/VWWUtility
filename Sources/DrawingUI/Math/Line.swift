//
// Line.swift
// Bezier
//
// Created by Zakk Hoyt on 9/6/21.
//

import CoreGraphics
import Foundation

struct Line: Identifiable {
    var id: CGFloat {
        point0.x + point0.y + point1.x + point1.y
    }
    
    /// An alternative to our `id` property which can certainly have duplicates.
    var uuid: UUID {
        UUID()
    }
    
    let point0: CGPoint
    let point1: CGPoint

    init(
        point0: CGPoint,
        point1: CGPoint
    ) {
        self.point0 = point0
        self.point1 = point1
    }

    init(
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
    var deltaX: CGFloat {
        point1.x - point0.x
    }

    var deltaY: CGFloat {
        point1.y - point0.y
    }
}

extension Line {
    /// - Returns: Angle (in radians) of a line between two points and in terms of 0 ... 2*CGFloat.pi
    var angle: CGFloat {
        CGFloat.project(
            angle: atan2(
                point1.y - point0.y,
                point1.x - point0.x
            )
        )
    }

    var reverseAngle: CGFloat {
        CGFloat.project(angle: angle - CGFloat.pi)
    }

    /// - Returns: Length of the line using pythagorean theorem
    var length: CGFloat {
        sqrt(
            pow(abs(point0.x - point1.x), 2) +
                pow(abs(point0.y - point1.y), 2)
        )
    }
}
