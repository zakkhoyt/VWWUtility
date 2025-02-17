//
// CGRect+Helpers.swift
//
// Created by Zakk Hoyt on 7/21/23.
//

import CoreGraphics

extension CGRect {
    public static let unit = CGRect(
        origin: .zero, size: .unit
    )
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

extension CGRect {
    public func contract(
        size maxSize: CGSize
    ) -> CGRect {
        CGRect(
            origin: origin.contract(size: maxSize),
            size: size.contract(size: maxSize)
        )
    }
    
    public func expand(
        size maxSize: CGSize
    ) -> CGRect {
        CGRect(
            origin: origin.expand(size: maxSize),
            size: size.expand(size: maxSize)
        )
    }
}
