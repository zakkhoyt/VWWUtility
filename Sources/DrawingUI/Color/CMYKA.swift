//
//  CMYKA.swift
//
//  Created by Zakk Hoyt on 10/22/16.
//  Copyright © 2016 Zakk Hoyt. All rights reserved.
//

import CoreGraphics

public struct CMYKA {
    public var cyan: CGFloat
    public var magenta: CGFloat
    public var yellow: CGFloat
    public var black: CGFloat
    public var alpha: CGFloat

    public init(cyan: CGFloat, magenta: CGFloat, yellow: CGFloat, black: CGFloat, alpha: CGFloat) {
        self.cyan = clip(cyan)
        self.magenta = clip(magenta)
        self.yellow = clip(yellow)
        self.black = clip(black)
        self.alpha = clip(alpha)
    }

    public init(cyan: CGFloat, magenta: CGFloat, yellow: CGFloat, black: CGFloat) {
        self.init(cyan: cyan, magenta: magenta, yellow: yellow, black: black, alpha: 1.0)
    }

    public func description() -> String {
        "cyan: " + String(format: "%.2f", cyan) +
            "magenta: " + String(format: "%.2f", magenta) +
            "yellow: " + String(format: "%.2f", yellow) +
            "black: " + String(format: "%.2f", black) +
            "alpha: " + String(format: "%.2f", alpha)
    }
    
    // http://www.rapidtables.com/convert/color/cmyk-to-rgb.htm
    public var rgba: RGBA {
        let red = (1.0 - cyan) * (1.0 - black)
        let green = (1.0 - magenta) * (1.0 - black)
        let blue = (1.0 - yellow) * (1.0 - black)
        return RGBA(red: red, green: green, blue: blue, alpha: alpha)
    }

    // MARK: Converstions

    public var hsba: HSBA {
        rgba.hsba
    }

    public var hsla: HSLA {
        rgba.hsla
    }
    
    public var yuva: YUVA {
        rgba.yuva
    }
}

extension CMYKA: ColorString {
    public func stringFor(type: ColorStringType) -> String {
        let format = type.format()
        let factor = type.factor()

        if type == .baseOne {
            let cyanString = String(format: format, cyan * factor)
            let magentaString = String(format: format, magenta * factor)
            let yellowString = String(format: format, yellow * factor)
            let blackString = String(format: format, black * factor)
            let alphaString = String(format: format, alpha * factor)
            let combined = "(\(cyanString), \(magentaString), \(yellowString), \(blackString), \(alphaString))"
            let cmykaString = "CMYKA: " + combined
            return cmykaString
        } else {
            let cyanString = String(format: format, Int(cyan * factor))
            let magentaString = String(format: format, Int(magenta * factor))
            let yellowString = String(format: format, Int(yellow * factor))
            let blackString = String(format: format, Int(black * factor))
            let alphaString = String(format: format, Int(alpha * factor))
            let combined = "(\(cyanString), \(magentaString), \(yellowString), \(blackString), \(alphaString))"
            let cmykaString = "CMYKA: " + combined
            return cmykaString
        }
    }
}
