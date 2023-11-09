//
//  Kelvin.swift
//  Multislider
//
//  Created by Zakk Hoyt on 2/24/18.
//  Copyright © 2018 Zakk Hoyt. All rights reserved.
//
//  https://gist.github.com/paulkaplan/5184275

import CoreGraphics

/// Represents the Kelvin color space
public struct Kelvin {
    public static let minimumDegrees: CGFloat = 1200
    public static let maximumDegrees: CGFloat = 12000 // 6500

    public static let candle: CGFloat = 1900
    public static let tungsten: CGFloat = 2700
    public static let halogen: CGFloat = 3400
    public static let flourescent: CGFloat = 4200
    public static let sunlight: CGFloat = 5500
    public static let daylight: CGFloat = 6500

    public private(set) var degrees: CGFloat

    public init(degrees: CGFloat) {
        self.degrees = degrees
    }

    // TODO: init(color: UIColor) // this shoudl match nearest kelvin possible

    public var rgba: RGBA {
        let temp: CGFloat = degrees / 100
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0

        if temp < 66 {
            red = 255
            green = temp
            green = 99.4708025861 * log(green) - 161.1195681661
            if temp <= 19 {
                blue = 0
            } else {
                blue = temp - 10
                blue = 138.5177312231 * log(blue) - 305.0447927307
            }
        } else {
            red = temp - 60
            red = 329.698727446 * pow(red, -0.1332047592)

            green = temp - 60
            green = 288.1221695283 * pow(green, -0.0755148492)

            blue = 255
        }

        red = max(0, min(255, red)) / 255
        green = max(0, min(255, green)) / 255
        blue = max(0, min(255, blue)) / 255

        return RGBA(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
