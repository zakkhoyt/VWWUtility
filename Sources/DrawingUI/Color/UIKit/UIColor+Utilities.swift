//
//  UIColor+Utilities.swift
//
//  Created by Zakk Hoyt on 9/24/16.
//  Copyright © 2016 Zakk Hoyt. All rights reserved.
//

#if os(iOS)
import UIKit

extension UIColor {
    // MARK: Class factory

    /// Create a UIColor with a hex string
    ///
    /// - parameter hexString: RRGGBB or #RRGGBB where RR, GG, and BB range from "00" to "FF"
    /// - parameter alpha:     Alpha value from 0.0 to 1.0
    ///
    /// - returns: UIColor instance
    public class func colorWith(hexString: String, alpha: CGFloat = 1.0) -> UIColor {
        UIColor(hexString: hexString, alpha: alpha)
    }

    // MARK: Init methods

    /// Create a UIColor with a hex string
    ///
    /// - parameter hexString: RRGGBB or #RRGGBB
    /// - parameter alpha:     An alpha value from 0.0 to 1.0
    ///
    /// - returns: UIColor instance
    public convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let color = hexString.hexStringValue

        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask

        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    // MARK: Helpers

    public var hexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        let rgb = Int(r * 255) << 16 | Int(g * 255) << 8 | Int(b * 255) << 0

        return String(format: "%06X", rgb).uppercased()
    }

    // swiftlint:disable large_tuple
        
    public class func interpolateAt(
        value: CGFloat,
        betweenColor1 color1: UIColor,
        andColor2 color2: UIColor
    ) -> UIColor {
        func rgba(
            color: UIColor
        ) -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            return (red, green, blue, alpha)
        }
        
        let rgba1 = rgba(color: color1)
        let rgba2 = rgba(color: color2)

        let redDiff = rgba2.red - rgba1.red
        let red = rgba1.red + redDiff * value

        let greenDiff = rgba2.green - rgba1.green
        let green = rgba1.green + greenDiff * value

        let blueDiff = rgba2.blue - rgba1.blue
        let blue = rgba1.blue + blueDiff * value

        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
        
    // swiftlint:enable large_tuple

    public class func random(alpha: CGFloat = 1.0) -> UIColor {
        let red = CGFloat.random(in: 0.0...1.0)
        let green = CGFloat.random(in: 0.0...1.0)
        let blue = CGFloat.random(in: 0.0...1.0)
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
#endif
