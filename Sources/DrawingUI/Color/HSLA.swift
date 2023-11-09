//
//  HSLA.swift
//  ColorPicKitExample
//
//  Created by Zakk Hoyt on 10/22/16.
//  Copyright © 2016 Zakk Hoyt. All rights reserved.
//

import CoreGraphics

/// Represents the HSLA color space
public struct HSLA {
    public var hue: CGFloat
    public var saturation: CGFloat
    public var lightness: CGFloat
    public var alpha: CGFloat

    public init(hue: CGFloat, saturation: CGFloat, lightness: CGFloat, alpha: CGFloat) {
        self.hue = clip(hue)
        self.saturation = clip(saturation)
        self.lightness = clip(lightness)
        self.alpha = clip(alpha)
    }

    public init(hue: CGFloat, saturation: CGFloat, lightness: CGFloat) {
        self.init(hue: hue, saturation: saturation, lightness: lightness, alpha: 1.0)
    }

    public func description() -> String {
        "hue: " + String(format: "%.2f", hue) +
            "saturation: " + String(format: "%.2f", saturation) +
            "lightness: " + String(format: "%.2f", lightness) +
            "alpha: " + String(format: "%.2f", alpha)
    }
    
    // MARK: Converstions

    public var rgba: RGBA {
        func hueToRGB(iv1: CGFloat, iv2: CGFloat, ivH: CGFloat) -> CGFloat {
            let v1: CGFloat = iv1
            let v2: CGFloat = iv2
            var vH: CGFloat = ivH

            if vH < 0 { vH += 1 }
            if vH > 1 { vH -= 1 }
            if (6 * vH) < 1 { return v1 + (v2 - v1) * 6 * vH }
            if (2 * vH) < 1 { return v2 }
            if (3 * vH) < 2 { return v1 + (v2 - v1) * ((2 / 3) - vH) * 6 }
            return v1
        }

        let hue = hue
        let saturation = saturation
        let lightness = lightness
        let alpha = alpha

        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0

        if saturation == 0 {
            red = lightness * 1.0
            green = lightness * 1.0
            blue = lightness * 1.0
        } else {
            var var_2: CGFloat = 0

            if lightness < 0.5 {
                var_2 = lightness * (1 + saturation)
            } else {
                var_2 = (lightness + saturation) - (saturation * lightness)
            }

            let var_1: CGFloat = 2 * lightness - var_2
            red = 1.0 * hueToRGB(iv1: var_1, iv2: var_2, ivH: hue + (1.0 / 3.0))
            green = 1.0 * hueToRGB(iv1: var_1, iv2: var_2, ivH: hue)
            blue = 1.0 * hueToRGB(iv1: var_1, iv2: var_2, ivH: hue - (1.0 / 3.0))
        }

        return RGBA(red: red, green: green, blue: blue, alpha: alpha)
    }

    public var hsba: HSBA {
        rgba.hsba
    }

    public var cmyka: CMYKA {
        rgba.cmyka
    }

    public var yuva: YUVA {
        rgba.yuva
    }
}

extension HSLA: ColorString {
    public func stringFor(type: ColorStringType) -> String {
        let format = type.format()
        let factor = type.factor()

        if type == .baseOne {
            let hue360 = String(format: "%.1f°", hue * 360.0)
            let hueString = String(format: format, hue * factor)
            let saturationString = String(format: format, saturation * factor)
            let lightnessString = String(format: format, lightness * factor)
            let alphaString = String(format: format, alpha * factor)
            let hsbaString = "HSLA: (\(hue360)) (\(hueString), \(saturationString), \(lightnessString), \(alphaString))"
            return hsbaString
        } else {
            let hue360 = String(format: "%.1f°", hue * 360.0)
            let hueString = String(format: format, Int(hue * factor))
            let saturationString = String(format: format, Int(saturation * factor))
            let lightnessString = String(format: format, Int(lightness * factor))
            let alphaString = String(format: format, Int(alpha * factor))
            let hsbaString = "HSLA: (\(hue360)) (\(hueString), \(saturationString), \(lightnessString), \(alphaString))"
            return hsbaString
        }
    }
}
