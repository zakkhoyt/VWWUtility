//
//  ColorPalette.swift
//  VWWUtility
//
//  Created by Zakk Hoyt on 2024-12-24.
//

//#if os(iOS)
//import UIKit
//#elseif os(macOS)
//import AppKit
//#endif

import SwiftUI

extension ColorPalette {

#warning(
    """
    TODO: zakkhoyt - Implement color palletters. 
    See reference photos
    * references/aura.png
    * references/citta.png
    * references/dim-light.png
    * references/gold.png
    * references/golden-red.png
    * references/iron-red.png
    * references/jungle.png
    * references/medical.png
    * references/rainbow.png
    * references/red-hot.png
    * hue 
    """
)
    public static let goldenRed = ColorPalette(
        keyColors: [
            ColorPalette.KeyColor(offset: 0.0, color: .black),
            ColorPalette.KeyColor(offset: 0.33, color: .red),
            ColorPalette.KeyColor(offset: 0.66, color: .yellow),
            ColorPalette.KeyColor(offset: 1.0, color: .white)
        ]
    )
}

extension ColorPalette: CaseIterable {
    public static var allCases: [ColorPalette] {
        [
//            .aura,
//            .citta,
//            .dimLight,
//            .gold,
            .goldenRed
//            .ironRed,
//            .jungle,
//            .medical,
//            .rainbow,
//            .redHot,
        ]
    }
}


/// Describes a 2 dimensional color palette where the input is a value
/// between 0...1 and the output is a `Color` and is interpolated from
/// a few key-colors.
public struct ColorPalette {
    public struct KeyColor {
        public init(offset: Double, color: Color) {
            self.offset = offset
            self.color = color
        }
        
        /// Indicates where the `Color` range  begins
        /// Normalized values in the range `0.0 ... 1.0`
        public let offset: Double
        public let color: Color
    }
    
    public let keyColors: [KeyColor]
   
    public static let defaultColor = Color.black

    /// At least 2 colors should be passed in. If only 1 color is passed in, that value
    /// willl be returned for all inputs. If 0 colors are passed in, black will be returned
    /// for all inputs.
    public init(keyColors: [KeyColor]) {
        self.keyColors = keyColors
    }
    
    /// Returns a `Color` that liest between two key-colors.
    /// The value is computed using linear interpolation.
    public func color(
        value v: Double
    ) -> Color {
        let value = v.clamped(to: 0...1)
        
        let offsets = keyColors
            .map{ $0.offset }
            .sorted { $0 < $1 }
    
        guard keyColors.count > 0 else {
            // No keyColors defined to interpolate with.
            return ColorPalette.defaultColor
        }
        guard keyColors.count > 1 else {
            // No enough keyColors interpolate with.
            return keyColors[0].color
        }
        
        // We have >= 2 keyCcolors. Now ensure that `value` lies between
        // two of them
        guard let prevIndex = (offsets.firstIndex { value >= $0 }),
              let nextIndex = (offsets.firstIndex { value <= $0 }) else {
            return ColorPalette.defaultColor
        }
        
        guard prevIndex >= 0, prevIndex < keyColors.count - 1,
              nextIndex >= 1, prevIndex < keyColors.count else {
            return ColorPalette.defaultColor
        }
        
        let prevKeyColor = keyColors[prevIndex]
        let nextKeyColor = keyColors[nextIndex]
        
        let portion = Double.project(
            value: value,
            lowerBoundIn: prevKeyColor.offset,
            upperBoundIn: nextKeyColor.offset,
            lowerBoundOut: 0.0,
            upperBoundOut: 1.0
        )
        
        return Color.interpolate(
            portion: portion,
            color1: prevKeyColor.color,
            color2: nextKeyColor.color
        )
    }
}

extension BinaryFloatingPoint {
    public func clamped(
        to range: ClosedRange<Self> = 0.0...1.0
    ) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
