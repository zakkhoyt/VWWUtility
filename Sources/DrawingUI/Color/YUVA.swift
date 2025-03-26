//
// YUVA.swift
//
// Created by Zakk Hoyt on 10/22/16.
// Copyright © 2016 Zakk Hoyt. All rights reserved.
//

import CoreGraphics

/// Represents the YUVA color space
public struct YUVA {
    // swiftlint:disable identifier_name
    public var y: CGFloat // intensity
    public var u: CGFloat // blue
    public var v: CGFloat // red

    public var alpha: CGFloat // alpha

    public init(y: CGFloat, u: CGFloat, v: CGFloat, alpha: CGFloat) {
        self.y = clip(y)
        self.u = clip(u)
        self.v = clip(v)
        self.alpha = clip(alpha)
    }

    public init(y: CGFloat, u: CGFloat, v: CGFloat) {
        self.init(y: y, u: u, v: v, alpha: 1.0)
    }

    public func description() -> String {
        "y: " + String(format: "%.2f", y) +
            "u: " + String(format: "%.2f", u) +
            "v: " + String(format: "%.2f", v) +
            "alpha: " + String(format: "%.2f", alpha)
    }
    
    // http://www.pcmag.com/encyclopedia/term/55166/yuv-rgb-conversion-formulas

    public var rgba: RGBA {
//        var red = yuva.y + 1.140 * yuva.v
//        var green = yuva.y - 0.395 * yuva.u - 0.581 * yuva.v
//        var blue = yuva.y + 2.032 * yuva.u

//        R  = Y +                       + (Cr - 128) *  1.40200
//        G  = Y + (Cb - 128) * -0.34414 + (Cr - 128) * -0.71414
//        B  = Y + (Cb - 128) *  1.77200

//        var red     = yuva.y +                             (yuva.u - 0.5) *  1.40200
//        var green   = yuva.y + (yuva.v - 0.5) * -0.34414 + (yuva.u - 0.5) * -0.71414
//        var blue    = yuva.y + (yuva.y - 0.5) *  1.77200

//        // http://www.equasys.de/colorconversion.html
//        let red = yuva.y * 1.0 + (yuva.u - 0.5) * 0.0 + (yuva.v - 0.5) * 1.140
//        let green = yuva.y * 1.0 + (yuva.u - 0.5) * -0.395 + (yuva.v - 0.5) * -0.581
//        let blue = yuva.y * 1.0 + (yuva.u - 0.5) * 2.032 + (yuva.v - 0.5) * 0

//        // http://www.equasys.de/colorconversion.html
//        let red =   yuva.y * 1.0000 + yuva.u * 0.0000 +     yuva.v * 1.1402     // 0.0 ... 1.0
//        let green = (yuva.y * 1.0000 + yuva.u * -0.3440 +    yuva.v * -0.7140) + 0.5    // -0.5 ... 0.5
//        let blue =  yuva.y * 1.0000 + yuva.u * 1.7720 +     yuva.v * 0.0000     // 0.0 ... 1.0

        // http://www.equasys.de/colorconversion.html
        let red = y * 1.0000 + (u - 0.5) * 0.0000 + (v - 0.5) * 1.1402 // 0.0 ... 1.0
        let green = (y * 1.0000 + (u - 0.5) * -0.3440 + (v - 0.5) * -0.7140) // -0.5 ... 0.5
        let blue = y * 1.0000 + (u - 0.5) * 1.7720 + (v - 0.5) * 0.0000 // 0.0 ... 1.0

//        // http://www.equasys.de/colorconversion.html
//        let red =   yuva.y * 1.0000 + yuva.u * 0.0000 +     yuva.v - 0.5 * 1.1402     // 0.0 ... 1.0
//        var green = yuva.y * 1.0000 + yuva.u * -0.3440 +   yuva.v - 0.5 * -0.7140     // -0.5 ... 0.5
//        green += 0.5
//        let blue =  yuva.y * 1.0000 + yuva.u * 1.7720 +     yuva.v - 0.5 * 0.0000     // 0.0 ... 1.0

//        // Took inverse matrix from RGBA to YUVA using this tool http://matrix.reshish.com/inverCalculation.php
//        let red     = yuva.y * 0.9998766121570952 + (yuva.v - 0.5) * 0.0000412426888942  + (yuva.u - 0.5) *  1.4020877012345512
//        let green   = yuva.y * 1.0000972642737906 + (yuva.v - 0.5) * -0.3441648864536546 + (yuva.u - 0.5) * -0.7141793967313819
//        let blue    = yuva.y * 0.9998227967982449 + (yuva.y - 0.5) * 1.7720390945080637  + (yuva.u - 0.5) * -0.0000080419983298
//

        // Experimenting with normalizing since RGB values go will above and below 0...1
//        (lldb) po redMin
//        -0.07
//
//
//        (lldb) po redMax
//        1.06724637681159
//
//
//        (lldb) po greenMin
//        0.0143574879227053
//
//
//        (lldb) po greenMax
//        0.988
//
//
//        (lldb) po blueMin
//        -0.516
//
//
//        (lldb) po blueMax
//        1.51109178743961
//
//        let redMax: CGFloat = 1.06724637681159
//        let redMin: CGFloat = -0.07
//        let redDiff = redMax - redMin
//        red = red - redMin / redDiff
//
//
//        let greenMax: CGFloat = 0.988
//        let greenMin: CGFloat = 0.0143574879227053
//        let greenDiff = greenMax - greenMin
//        green = green - greenMin / greenDiff
//
//
//        let blueMax: CGFloat = 1.51109178743961
//        let blueMin: CGFloat = -0.516
//        let blueDiff = blueMax - blueMin
//        blue = blue - blueMin / blueDiff

//        if red > 1.0 {
//            red = 1.0
//
//        }
//        if red < 0 {
//            red = 0
//        }
//
//        if green > 1.0 {
//            green = 1.0
//
//        }
//        if green < 0 {
//            green = 0
//        }
//
//        if blue > 1.0 {
//            blue = 1.0
//
//        }
//        if blue < 0 {
//            blue = 0
//        }

        let rgba = RGBA(red: red, green: green, blue: blue, alpha: alpha)
        return rgba
    }

    public var hsba: HSBA {
        rgba.hsba
    }

    public var hsla: HSLA {
        rgba.hsla
    }

    public var cmyka: CMYKA {
        rgba.cmyka
    }
}

extension YUVA: ColorString {
    public func stringFor(type: ColorStringType) -> String {
        let format = type.format()
        let factor = type.factor()

        if type == .baseOne {
            let yString = String(format: format, y * factor)
            let uString = String(format: format, u * factor)
            let vString = String(format: format, v * factor)
            let alphaString = String(format: format, alpha * factor)
            let yuva = "YUVA: (\(yString), \(uString), \(vString), \(alphaString))"
            return yuva
        } else {
            let yString = String(format: format, Int(y * factor))
            let uString = String(format: format, Int(u * factor))
            let vString = String(format: format, Int(v * factor))
            let alphaString = String(format: format, Int(alpha * factor))
            let yuva = "YUVA: (\(yString), \(uString), \(vString), \(alphaString))"
            return yuva
        }
    }
    
    // swiftlint:enable identifier_name
}
