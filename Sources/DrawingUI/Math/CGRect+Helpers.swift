//
//  CGRect+Helpers.swift
//
//  Created by Zakk Hoyt on 7/21/23.
//

import CoreGraphics

extension CGRect {
    public static let unitRect = CGRect(x: 0, y: 0, width: 1, height: 1)
}

extension CGRect {
    public var center: CGPoint {
        CGPoint(
            x: origin.x + size.width / 2,
            y: origin.y + size.height / 2
        )
    }
}

extension CGRect {
    public func point(
        xPercent: Double,
        yPercent: Double
    ) -> CGPoint {
        CGPoint(
            x: origin.x + size.width * xPercent,
            y: origin.y + size.height * yPercent
        )
    }
}
