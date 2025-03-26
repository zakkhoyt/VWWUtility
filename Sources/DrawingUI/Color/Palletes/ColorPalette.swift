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

import BaseUtility
import SwiftUI

extension ColorPalette {
    public static let aura = ColorPalette(
        keyColors: [
            ColorPalette.KeyColor(offset: 0.0, color: Color(hexString: "FFFFE0")),
            ColorPalette.KeyColor(offset: 0.05, color: Color(hexString: "F2D75A")),
            ColorPalette.KeyColor(offset: 0.11, color: Color(hexString: "F2A503")),
            ColorPalette.KeyColor(offset: 0.25, color: Color(hexString: "E82500")),
            ColorPalette.KeyColor(offset: 0.45, color: Color(hexString: "37Ae71")),
            ColorPalette.KeyColor(offset: 0.545, color: Color(hexString: "09CAc7")),
            ColorPalette.KeyColor(offset: 0.62, color: Color(hexString: "08ADF4")),
            ColorPalette.KeyColor(offset: 0.73, color: Color(hexString: "3636E0")),
            ColorPalette.KeyColor(offset: 0.83, color: Color(hexString: "510061")),
            ColorPalette.KeyColor(offset: 0.90, color: Color(hexString: "3D001D")),
            ColorPalette.KeyColor(offset: 0.95, color: Color(hexString: "24000A")),
            ColorPalette.KeyColor(offset: 1.00, color: Color(hexString: "000000")),
        ]
    )
    
    public static let citta = ColorPalette(
        keyColors: [
            ColorPalette.KeyColor(offset: 0.0, color: Color(hexString: "FFFFDB")),
            ColorPalette.KeyColor(offset: 0.1, color: Color(hexString: "FAEA5B")),
            ColorPalette.KeyColor(offset: 0.29, color: Color(hexString: "CE5B37")),
            ColorPalette.KeyColor(offset: 0.45, color: Color(hexString: "839B77")),
            ColorPalette.KeyColor(offset: 0.60, color: Color(hexString: "78E1C4")),
            ColorPalette.KeyColor(offset: 0.69, color: Color(hexString: "59B3EB")),
            ColorPalette.KeyColor(offset: 1.00, color: Color(hexString: "0000FF")),
        ]
    )

    public static let dimLight = ColorPalette(
        keyColors: [
            ColorPalette.KeyColor(offset: 0.0, color: Color(hexString: "BEFBD9")),
            ColorPalette.KeyColor(offset: 0.25, color: Color(hexString: "389800")),
            ColorPalette.KeyColor(offset: 0.5, color: Color(hexString: "184C00")),
            ColorPalette.KeyColor(offset: 1.00, color: Color(hexString: "000000")),
        ]
    )

    
    public static let gold = ColorPalette(
        keyColors: [
            ColorPalette.KeyColor(offset: 0.0, color: Color(hexString: "FCE556")),
//            ColorPalette.KeyColor(offset: 0.25, color: Color(hexString: "c28c00")),
            ColorPalette.KeyColor(offset: 0.5, color: Color(hexString: "8E3A01")),
            ColorPalette.KeyColor(offset: 0.75, color: Color(hexString: "560901")),
            ColorPalette.KeyColor(offset: 1.00, color: Color(hexString: "000000")),
        ]
    )
    
    public static let goldenRed = ColorPalette(
        keyColors: [
            ColorPalette.KeyColor(offset: 0.0, color: Color(hexString: "FFFFFF")),
            ColorPalette.KeyColor(offset: 0.25, color: Color(hexString: "FCCC26")),
            ColorPalette.KeyColor(offset: 0.5, color: Color(hexString: "F85F00")),
            ColorPalette.KeyColor(offset: 0.75, color: Color(hexString: "AE0000")),
            ColorPalette.KeyColor(offset: 1.00, color: Color(hexString: "000000")),
        ]
    )
 
    public static let ironRed = ColorPalette(
        keyColors: [
            ColorPalette.KeyColor(offset: 0.0, color: Color(hexString: "FFFFDB")),
            ColorPalette.KeyColor(offset: 0.25, color: Color(hexString: "F9B500")), // yellow orange
            ColorPalette.KeyColor(offset: 0.50, color: Color(hexString: "DE3F2A")),
            ColorPalette.KeyColor(offset: 0.75, color: Color(hexString: "5A0BA5")),
            ColorPalette.KeyColor(offset: 1.0, color: Color(hexString: "000030"))
        ]
    )

    public static let jungle = ColorPalette(
        keyColors: [
            ColorPalette.KeyColor(offset: 0.0, color: Color(hexString: "FF0000")), // red
            ColorPalette.KeyColor(offset: 0.3, color: Color(hexString: "E8E821")), // yellow
            ColorPalette.KeyColor(offset: 0.42, color: Color(hexString: "90FD52")), // green
            ColorPalette.KeyColor(offset: 0.62, color: Color(hexString: "05A27C")), // teal
            ColorPalette.KeyColor(offset: 0.82, color: Color(hexString: "003854")), // blue
            ColorPalette.KeyColor(offset: 1.0, color: Color(hexString: "000000")), // black
        ]
    )


    public static let medical = ColorPalette(
        keyColors: [
            ColorPalette.KeyColor(offset: 0.0, color: Color(hexString: "FFFFFF")), // white 0%
            ColorPalette.KeyColor(offset: 0.125, color: Color(hexString: "FD1F59")), // red 12.5%
            ColorPalette.KeyColor(offset: 0.262, color: Color(hexString: "F7F71E")), // yellow 26.2%
            ColorPalette.KeyColor(offset: 0.36, color: Color(hexString: "9F9003")), // brown 36%
            ColorPalette.KeyColor(offset: 0.482, color: Color(hexString: "5DF21C")), // gren 48.2%
            ColorPalette.KeyColor(offset: 0.752, color: Color(hexString: "0020ED")), // blue 75.2%
            ColorPalette.KeyColor(offset: 0.92, color: Color(hexString: "E24FDA")), // magenta 92%
            ColorPalette.KeyColor(offset: 1.0, color: Color(hexString: "222222")), // dark gray 1000%
        ]
    )
    
    public static let rainbow = ColorPalette(
        keyColors: [
            ColorPalette.KeyColor(offset: 0.0, color: Color(hexString: "FF0000")), // red 0%
            ColorPalette.KeyColor(offset: 0.33, color: Color(hexString: "DBDB07")), // yellow 33%
            ColorPalette.KeyColor(offset: 0.66, color: Color(hexString: "34A77C")), // green 66
            ColorPalette.KeyColor(offset: 0.865, color: Color(hexString: "0627cb")), // blue 86.5%
            ColorPalette.KeyColor(offset: 1.00, color: Color(hexString: "370249")) // violet 100
        ]
    )
    
    public static let redHot = ColorPalette(
        keyColors: [
            ColorPalette.KeyColor(offset: 0.0, color: Color(hexString: "FF3030")),
            ColorPalette.KeyColor(offset: 0.21, color: Color(hexString: "DFDFDF")),
            ColorPalette.KeyColor(offset: 1.0, color: Color(hexString: "020202"))
        ]
    )
    
    public static let grayscale = ColorPalette(
        keyColors: [
            ColorPalette.KeyColor(offset: 0.0, color: Color(hexString: "000000")),
            ColorPalette.KeyColor(offset: 1.0, color: Color(hexString: "FFFFFF"))
        ]
    )
    
    public static let invertedGrayscale = ColorPalette(
        keyColors: [
            ColorPalette.KeyColor(offset: 1.0, color: Color(hexString: "FFFFFF")),
            ColorPalette.KeyColor(offset: 0.0, color: Color(hexString: "000000"))
        ]
    )
}

extension ColorPalette: CaseIterable {
    public static var allCases: [ColorPalette] {
        [
            .aura,
            .citta,
            .dimLight,
            .gold,
            .goldenRed,
            .ironRed,
            .jungle,
            .medical,
            .rainbow,
            .redHot,
            .grayscale,
            .invertedGrayscale
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
            logger.warning("0 keyColors to interpolate with.")
            return ColorPalette.defaultColor
        }
        guard keyColors.count > 1 else {
            // Not enough keyColors interpolate with.
            logger.warning("Only 1 keyColor to interpolate with.")
            return keyColors[0].color
        }
        
#warning(
    """
    TODO: zakkhoyt - Options to speed up performanc:
    * binary search
    * Divide in to some number of samples upon first use (like 128) 
    """
        )
        // We have >= 2 keyCcolors. Now ensure that `value` lies between
        // two of them
        guard let prevIndex = (offsets.lastIndex { value >= $0 }),
              let nextIndex = (offsets.firstIndex { value <= $0 }) else {
            logger.warning("value does not lie between previous and next indexes")
            return ColorPalette.defaultColor
        }
        
        guard prevIndex >= 0, prevIndex < keyColors.count - 1 else {
            logger.warning("prevIndex (\(prevIndex)) < 0 || >= keyColors.count - 1 \(keyColors.count - 1)")
            return ColorPalette.defaultColor
        }
        guard nextIndex >= 1, prevIndex < keyColors.count else {
            logger.warning("nextIndex (\(prevIndex)) < 1 || >= keyColors.count \(keyColors.count)")
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
        
        logger.debug("prev.offset \(prevKeyColor.offset) < value (\(value)) < next.offset \(nextKeyColor.offset)")
//        logger.debug("prev.offset \(prevKeyColor.offset) < value (\(value)) < next.offset \(nextKeyColor.offset)")
        
        
        
        return Color.interpolate(
            portion: portion,
            color1: prevKeyColor.color,
            color2: nextKeyColor.color
        )
    }
}


