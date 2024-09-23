//
// UIView+Helpers.swift
// Mathic
//
// Created by Zakk Hoyt on 5/9/20.
// Copyright © 2020 Zakk Hoyt. All rights reserved.
//

#if os(iOS)
import UIKit

extension UIView {
    /// bounds minus the safeAreaInset
    public var safeAreaSize: CGSize {
        let width = bounds.width - (safeAreaInsets.left + safeAreaInsets.right)
        let height = bounds.height - (safeAreaInsets.top + safeAreaInsets.bottom)
        return CGSize(width: width, height: height)
    }
}

extension UIView {
    /// Given input of CGPoint with x/y 0...1, scale the output to self.bounds
    func expand(point: CGPoint) -> CGPoint {
        let x = bounds.origin.x + bounds.width * point.x
        let y = bounds.origin.y + bounds.height * (1.0 - point.y)
        let point = CGPoint(x: x, y: y)
        return point
    }

    /// Given input of CGPoint with x/y 0...bounds.size, scale the output to 0...1
    func contract(point: CGPoint) -> CGPoint {
        let x = point.x / bounds.width
        let y = point.y / bounds.height
        let point = CGPoint(x: x, y: 1.0 - y)
        return point
    }
}
#endif
