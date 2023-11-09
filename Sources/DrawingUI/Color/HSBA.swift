//
//  HSBA.swift
//
//  Created by Zakk Hoyt on 10/22/16.
//  Copyright © 2016 Zakk Hoyt. All rights reserved.
//

import CoreGraphics

/// Represents the HSBA color space
public struct HSBA {
    public var hue: CGFloat
    public var saturation: CGFloat
    public var brightness: CGFloat
    public var alpha: CGFloat

    public init(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        self.hue = clip(hue)
        self.saturation = clip(saturation)
        self.brightness = clip(brightness)
        self.alpha = clip(alpha)
    }

    public init(hue: CGFloat, saturation: CGFloat, brightness: CGFloat) {
        self.init(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }

    public func description() -> String {
        "hue: " + String(format: "%.2f", hue) +
            "saturation: " + String(format: "%.2f", saturation) +
            "brightness: " + String(format: "%.2f", brightness) +
            "alpha: " + String(format: "%.2f", alpha)
    }
    
    // MARK: Converstions

    public var rgba: RGBA {
        // http://www.easyrgb.com/en/math.php
        // H, S and V input range = 0 ÷ 1.0
        // R, G and B output range = 0 ÷ 255
        
        let H = hue
        let S = saturation
        let V = brightness
        
        var R: CGFloat = 0
        var G: CGFloat = 0
        var B: CGFloat = 0

        if S == 0 {
            R = V // * 255
            G = V // * 255
            B = V // * 255
        } else {
            var var_h = H * 6
            if var_h == 6 {
                var_h = 0 // H must be < 1
            }
            
            let var_i = floor(var_h) // Or ... var_i = floor( var_h )
            let var_1 = V * (1 - S)
            let var_2 = V * (1 - S * (var_h - var_i))
            let var_3 = V * (1 - S * (1 - (var_h - var_i)))
            
            var var_r: CGFloat = 0
            var var_g: CGFloat = 0
            var var_b: CGFloat = 0
            
            if var_i == 0 {
                var_r = V
                var_g = var_3
                var_b = var_1
            } else if var_i == 1 {
                var_r = var_2
                var_g = V
                var_b = var_1
            } else if var_i == 2 {
                var_r = var_1
                var_g = V
                var_b = var_3
            } else if var_i == 3 {
                var_r = var_1
                var_g = var_2
                var_b = V
            } else if var_i == 4 {
                var_r = var_3
                var_g = var_1
                var_b = V
            } else {
                var_r = V
                var_g = var_1
                var_b = var_2
            }
            
            //           R = var_r // * 255
            //           G = var_g // * 255
            //           B = var_b // * 255
            
            R = var_r
            G = var_g
            B = var_b
        }
        return RGBA(
            red: R,
            green: G,
            blue: B,
            alpha: alpha
        )
    }
    
    public var hsla: HSLA {
        rgba.hsla
    }
    
    public var cmyka: CMYKA {
        rgba.cmyka
    }
    
    public var yuva: YUVA {
        rgba.yuva
    }
}

extension HSBA: ColorString {
    public func stringFor(type: ColorStringType) -> String {
        let format = type.format()
        let factor = type.factor()

        if type == .baseOne {
            let hue360 = String(format: "%.1f°", hue * 360.0)
            let hueString = String(format: format, hue * factor)
            let saturationString = String(format: format, saturation * factor)
            let brightnessString = String(format: format, brightness * factor)
            let alphaString = String(format: format, alpha * factor)
            let combined = "(\(hue360)) (\(hueString), \(saturationString), \(brightnessString), \(alphaString))"
            let hsbaString = "HSBA: " + combined
            return hsbaString
        } else {
            let hue360 = String(format: "%.1f°", hue * 360.0)
            let hueString = String(format: format, Int(hue * factor))
            let saturationString = String(format: format, Int(saturation * factor))
            let brightnessString = String(format: format, Int(brightness * factor))
            let alphaString = String(format: format, Int(alpha * factor))
            let combined = "(\(hue360)) (\(hueString), \(saturationString), \(brightnessString), \(alphaString))"
            let hsbaString = "HSBA: " + combined
            return hsbaString
        }
    }
}
