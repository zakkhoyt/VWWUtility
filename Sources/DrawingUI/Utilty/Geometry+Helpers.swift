//
// Geometry+Helpers.swift
// Bezier
//
// Created by Zakk Hoyt on 9/5/21.
//

import Foundation
import SwiftUI

extension GeometryProxy {
    /// Given input of CGPoint with x/y 0...1, scale the output to self.size
    public func expand(point: CGPoint) -> CGPoint {
        CGPoint(
            x: size.width * point.x,
            y: size.height * point.y
        )
    }
    
    /// Given input of CGPoint with x/y 0...bounds.size, scale the output to 0...1
    public func contract(point: CGPoint) -> CGPoint {
        CGPoint(
            x: point.x / size.width,
            y: point.y / size.height
        )
    }
}

extension GeometryProxy {
    /// Given input of CGSize with width/height in 0...1, scale the output to self.size
    public func expand(size s: CGSize) -> CGSize {
        CGSize(
            width: s.width * size.width,
            height: s.height * size.height
        )
    }
    
    public func contract(size: CGSize) -> CGSize {
        CGSize(
            width: size.width / self.size.width,
            height: size.height / self.size.height
        )
    }
}

extension GeometryProxy {
    public func expand(rect: CGRect) -> CGRect {
        CGRect(
            origin: expand(point: rect.origin),
            size: expand(size: rect.size)
        )
    }
    
    public func contract(rect: CGRect) -> CGRect {
        CGRect(
            origin: contract(point: rect.origin),
            size: contract(size: rect.size)
        )
    }
}
    
extension GeometryProxy {
    /// Given input of Line with points x/y 0...1, scale the output to self.size
    public func expand(line: CGLine) -> CGLine {
        CGLine(
            point0: expand(point: line.point0),
            point1: expand(point: line.point1)
        )
    }
    
    /// Given input of Line with points x/y 0...bounds.size, scale the output to 0...1
    public func contract(line: CGLine) -> CGLine {
        CGLine(
            point0: contract(point: line.point0),
            point1: contract(point: line.point1)
        )
    }
}

extension GeometryProxy {
    /// Returns a `CGRect` for the largest centered square possible.
    public var centeredSquare: CGRect {
        size.centeredSquare
    }
    
    /// Returns the smaller of width, height
    public var maximumDimension: CGFloat {
        size.maximumDimension
    }
    
    /// Returns the smaller of width, height
    public var minimumDimension: CGFloat {
        size.minimumDimension
    }
    
    public enum Orientation {
        case portrait
        case landscape
    }
    
    public var isLandscape: Bool {
        size.width > size.height
    }
    
    public var isPortrait: Bool {
        !isLandscape
    }
}

extension CGPoint {
    public func clip(to geometry: GeometryProxy) -> CGPoint {
        clip(to: geometry.size)
    }
}
