//
// CGSize+Helpers.swift
// Sudoku-iOS
//
// Created by Zakk Hoyt on 5/22/22.
// Copyright © 2022 Zakk Hoyt. All rights reserved.
//

import CoreGraphics


extension CGSize {
    public func contract(
        size: CGSize
    ) -> CGSize {
        
        let out = CGSize(
            width: width.contract(max: size.width),
            height: height.contract(max: size.height)
        )
        logger.debug("CGSize.contact. width: \(width) / \(size.width) = \(out.width)")
        logger.debug("CGSize.contact. height: \(height) / \(size.height) = \(out.height)")
        return out
    }
    
    public func expand(
        size: CGSize
    ) -> CGSize {
        CGSize(
            width: width * size.width,
            height: height * size.height
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

extension CGSize {
    public static func / (lhs: CGSize, rhs: Int) -> CGSize {
        CGSize(width: lhs.width / CGFloat(rhs), height: lhs.height / CGFloat(rhs))
    }

    public func divide(by divisor: CGFloat) -> CGSize {
        CGSize(width: width / divisor, height: height / divisor)
    }
}

extension CGSize {
    /// Returns the larger of width, height
    public var maximumDimension: CGFloat {
        max(width, height)
    }
    
    /// Returns the smaller of width, height
    public var minimumDimension: CGFloat {
        min(width, height)
    }

    /// Returns a `CGRect` for the largest centered square possible.
    public var centeredSquare: CGRect {
        let edge = min(width, height)
        if width < height {
            return CGRect(
                origin: CGPoint(
                    x: 0,
                    y: (height - edge) / 2
                ),
                size: CGSize(
                    width: edge,
                    height: edge
                )
            )
        } else {
            return CGRect(
                origin: CGPoint(
                    x: (width - edge) / 2,
                    y: 0
                ),
                size: CGSize(
                    width: edge,
                    height: edge
                )
            )
        }
    }
}

extension CGSize {
    public static let unit = CGSize(
        width: 1,
        height: 1
    )
    
    @available(*, unavailable, renamed: "unit")
    public static let one = unit
}

extension CGSize {
    public func gridLines(
        xDivisions: Int,
        yDivisions: Int
    ) -> ([CGLine], [CGLine]) {
        let rowHeight = CGFloat(1) / CGFloat(yDivisions)
        let rowLines: [CGLine] = (0...yDivisions).map { y in
            CGLine(
                point0: CGPoint(
                    x: CGFloat(0),
                    y: rowHeight * CGFloat(y)
                ),
                point1: CGPoint(
                    x: CGFloat(1),
                    y: rowHeight * CGFloat(y)
                )
            )
        }
        
        let columnWidth = CGFloat(1) / CGFloat(xDivisions)
        let columnLines: [CGLine] = (0...xDivisions).map { x in
            CGLine(
                point0: CGPoint(
                    x: columnWidth * CGFloat(x),
                    y: CGFloat(0)
                ),
                point1: CGPoint(
                    x: columnWidth * CGFloat(x),
                    y: CGFloat(1)
                )
            )
        }
        return (rowLines, columnLines)
    }
}

extension CGSize {
    public func gridRects(
        divisions: Int
    ) -> [CGRect] {
        gridRects(
            xDivisions: divisions,
            yDivisions: divisions
        )
    }
    
    public func gridRects(
        xDivisions: Int,
        yDivisions: Int
    ) -> [CGRect] {
        // TOOD: Look up nested forEach
        let gridWidth = CGFloat(width) / CGFloat(xDivisions)
        let gridHeight = CGFloat(height) / CGFloat(yDivisions)
        return (0..<yDivisions).reduce([]) { partialResult, y in
            partialResult + (0..<xDivisions).map { x in
                CGRect(
                    x: CGFloat(x) * gridWidth,
                    y: CGFloat(y) * gridHeight,
                    width: gridWidth,
                    height: gridHeight
                )
            }
        }
    }
}
