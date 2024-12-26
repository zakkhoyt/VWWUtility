//
//  RGBA.swift
//
//  Created by Zakk Hoyt on 10/22/16.
//  Copyright © 2016 Zakk Hoyt. All rights reserved.
//

import CoreGraphics

// TODO: zakkhoyt rename to reflect all color formats?
protocol RGBHexStringConvertible {
    var hexString: String { get }
}

/// Represents the RGBA color space
public struct RGBA {
    public var red: CGFloat
    public var green: CGFloat
    public var blue: CGFloat
    public var alpha: CGFloat

    public init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        self.red = clip(red)
        self.green = clip(green)
        self.blue = clip(blue)
        self.alpha = clip(alpha)
    }

    public init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }

    public func description() -> String {
        "red: " + String(format: "%.2f", red) +
            "green: " + String(format: "%.2f", green) +
            "blue: " + String(format: "%.2f", blue) +
            "alpha: " + String(format: "%.2f", alpha)
    }
    
    // MARK: conversions

    public var hsba: HSBA {
        let rgbMin = min(red, green, blue)
        let rgbMax = max(red, green, blue)
        let delta = rgbMax - rgbMin
        
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        let brightness: CGFloat = rgbMax

        if delta == 0 {
            // This is a gray, no chroma...
        } else {
            // Chromatic data...
            saturation = delta / rgbMax

            let deltaRed = (((rgbMax - red) / 6.0) + (delta / 2.0)) / delta
            let deltaGreen = (((rgbMax - green) / 6.0) + (delta / 2.0)) / delta
            let deltaBlue = (((rgbMax - blue) / 6.0) + (delta / 2.0)) / delta

            if red == rgbMax {
                hue = deltaBlue - deltaGreen
            } else if green == rgbMax {
                hue = (1.0 / 3.0) + deltaRed - deltaBlue
            } else if blue == rgbMax {
                hue = (2.0 / 3.0) + deltaGreen - deltaRed
            }
            
            hue = min(max(hue, 0), 1)
        }
        return HSBA(
            hue: hue,
            saturation: saturation,
            brightness: brightness,
            alpha: alpha
        )
    }

    public var hsla: HSLA {
        // http://www.easyrgb.com/index.php?X=MATH
        // http://stackoverflow.com/questions/2353211/hsl-to-rgb-color-conversion

        let rgbMin = min(red, green, blue)
        let rgbMax = max(red, green, blue)
        let delta = rgbMax - rgbMin

        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        let lightness: CGFloat = (rgbMax + rgbMin) / 2

        if delta == 0 {
            // This is a gray, no chroma...
        } else {
            if lightness < 0.5 {
                saturation = delta / (rgbMax + rgbMin)
            } else {
                saturation = delta / (2.0 - rgbMax - rgbMin)
            }

            let deltaRed = (((rgbMax - red) / 6.0) + (delta / 2.0)) / delta
            let deltaGreen = (((rgbMax - green) / 6.0) + (delta / 2.0)) / delta
            let deltaBlue = (((rgbMax - blue) / 6.0) + (delta / 2.0)) / delta

            if red == rgbMax {
                hue = deltaBlue - deltaGreen
            } else if green == rgbMax {
                hue = (1.0 / 3.0) + deltaRed - deltaBlue
            } else if blue == rgbMax {
                hue = (2.0 / 3.0) + deltaGreen - deltaRed
            }

            hue = min(max(hue, 0), 1)
        }
        
        return HSLA(
            hue: hue,
            saturation: saturation,
            lightness: lightness,
            alpha: alpha
        )
    }

    // http://www.rapidtables.com/convert/color/rgb-to-cmyk.htm
    public var cmyka: CMYKA {
        // Let's use almostOne so we don't end up with NaN
        let almostOne = CGFloat(1.00000000000001)
        let black = 1 - max(red, green, blue)
        let cyan = (1.0 - red - black) / (almostOne - black)
        let magenta = (1.0 - green - black) / (almostOne - black)
        let yellow = (1.0 - blue - black) / (almostOne - black)
        return CMYKA(cyan: cyan, magenta: magenta, yellow: yellow, black: black, alpha: alpha)
    }

    public var yuva: YUVA {
        // http://www.pcmag.com/encyclopedia/term/55166/yuv-rgb-conversion-formulas
        // http://www.equasys.de/colorconversion.html

//        // Multiply matrices
//        let y = rgba.red * 0.299 + rgba.green * 0.587 + rgba.blue * 0.114
//        let u = rgba.red * -0.147 + rgba.green * -0.289 + rgba.blue * 0.436 + 0.5
//        let v = rgba.red * 0.615 + rgba.green * -0.515 + rgba.blue * -0.100 + 0.5
//        let yuva = YUVA(y: y, u: u, v: v, alpha: rgba.alpha)
//        return yuva

        //        // https://en.wikipedia.org/wiki/YCbCr
        //        // YPbPr
        //        // Multiply matrices
        //        let y = rgba.red * 0.299 +      rgba.green * 0.587 +        rgba.blue * 0.114      // 0.0 ... 1.0
        //        let u = rgba.red * -0.168736 +  rgba.green * -0.331264 +    rgba.blue * 0.5        // 0.0 ... 1.0
        //        var v = rgba.red * 0.5 +        rgba.green * -0.418688 +    rgba.blue * -0.081312  // -0.5 ... 0.5
        //        v = v + 0.5
        //        let yuva = YUVA(y: y, u: u, v: v, alpha: rgba.alpha)
        //        return yuva

        // https://en.wikipedia.org/wiki/YCbCr
        // YPbPr
        // Multiply matrices
        let y = red * 0.299 + green * 0.587 + blue * 0.114 // 0.0 ... 1.0
        let u = (red * -0.168736 + green * -0.331264 + blue * 0.5) + 0.5 // 0.0 ... 1.0
        let v = (red * 0.5 + green * -0.418688 + blue * -0.081312) + 0.5 // -0.5 ... 0.5
        let yuva = YUVA(y: y, u: u, v: v, alpha: alpha)
        return yuva
    }
}

extension RGBA: ColorString {
    public func stringFor(type: ColorStringType) -> String {
        let format = type.format()
        let factor = type.factor()

        if type == .baseOne {
            let redString = String(format: format, red * factor)
            let greenString = String(format: format, green * factor)
            let blueString = String(format: format, blue * factor)
            let alphaString = String(format: format, alpha * factor)
            let rgbString = "RGBA: (\(redString), \(greenString), \(blueString), \(alphaString))"
            return rgbString
        } else {
            let redString = String(format: format, Int(red * factor))
            let greenString = String(format: format, Int(green * factor))
            let blueString = String(format: format, Int(blue * factor))
            let alphaString = String(format: format, Int(alpha * factor))
            let rgbString = "RGBA: (\(redString), \(greenString), \(blueString), \(alphaString))"
            return rgbString
        }
    }
}

extension RGBA {
    /// Interpolates between `color1` and `color2` using `portion` which
    /// is a `Double` in `0.0...1.0`
    public static func interpolate(
        portion: Double,
        rgba1: RGBA,
        rgba2: RGBA,
        includeAlpha: Bool = false
    ) -> RGBA {
        RGBA(
//            red: Double.interpolate(percent: portion, lower: rgba1.red, upper: rgba2.red),
//            green: Double.interpolate(percent: portion, lower: rgba1.green, upper: rgba2.green),
//            blue: Double.interpolate(percent: portion, lower: rgba1.blue, upper: rgba2.blue),
//            red: Double.project(
//                value: portion,
//                lowerBoundIn: 0.0,
//                upperBoundIn: 1.0,
//                lowerBoundOut: rgba1.red,
//                upperBoundOut: rgba2.red
//            ),
//            green: Double.project(
//                value: portion,
//                lowerBoundIn: 0.0,
//                upperBoundIn: 1.0,
//                lowerBoundOut: rgba1.green,
//                upperBoundOut: rgba2.green
//            ),
//            blue: Double.project(
//                value: portion,
//                lowerBoundIn: 0.0,
//                upperBoundIn: 1.0,
//                lowerBoundOut: rgba1.blue,
//                upperBoundOut: rgba2.blue
//            ),
            red: Double.project(
                value: portion,
                lowerBoundIn: 0.0,
                upperBoundIn: 1.0,
                lowerBoundOut: rgba1.red,
                upperBoundOut: rgba2.red
            ),
            green: Double.project(
                value: portion,
                lowerBoundIn: 0.0,
                upperBoundIn: 1.0,
                lowerBoundOut: rgba1.green,
                upperBoundOut: rgba2.green
            ),
            blue: Double.project(
                value: portion,
                lowerBoundIn: 0.0,
                upperBoundIn: 1.0,
                lowerBoundOut: rgba1.blue,
                upperBoundOut: rgba2.blue
            ),

            alpha: includeAlpha ? Double.interpolate(percent: portion, lower: rgba1.alpha, upper: rgba2.alpha) : 1.0
        )
    }
    
    /// Interpolates between `color1` and `color2` using `portion` which
    /// is a `Double` in `0.0...1.0`
    public func interpolating(
        portion: Double,
        rgba: RGBA,
        includeAlpha: Bool = false
    ) -> RGBA {
        RGBA.interpolate(portion: portion, rgba1: self, rgba2: rgba, includeAlpha: includeAlpha)
    }
}
//
