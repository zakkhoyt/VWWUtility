//
//  Color+Utilities.swift
//
//  Created by Zakk Hoyt on 6/27/23.
//

import SwiftUI

enum ROYGBIV: Int, CaseIterable, RGBHexStringConvertible {
    case red
    case orange
    case yellow
    case green
    case blue
    case indigo
    case violet
    
    var hexString: String {
        switch self {
        case .red: "FF0000"
        case .orange: "FF7F00"
        case .yellow: "FFFFOO"
        case .green: "00FFOO"
        case .blue: "0000FF"
        case .indigo: "4B0082"
        case .violet: "9400D3"
        }
    }
    
    static var random: ROYGBIV {
        ROYGBIV(rawValue: .random(in: 0..<ROYGBIV.allCases.count)) ?? .red
    }
}

extension Color {
    public init(
        hexString: String,
        opacity: Double = 1.0
    ) {
        let color = hexString.hexStringValue
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red = Double(r) / 255.0
        let green = Double(g) / 255.0
        let blue = Double(b) / 255.0
        
        self.init(red: red, green: green, blue: blue, opacity: opacity)
    }
}

extension Color {
    /// Returns a random rainbow (ROYGBIV) `Color`.
    public static var randomROYGBIV: Color {
        Color(hexString: ROYGBIV.random.hexString)
    }

    /// Generates a Color using random RGB values.
    /// - Parameters:
    ///   - rgbMin: The minimum random value to use for `RGB` values. Defaults to `0.0`
    ///   - rgbMax: The maximum random value to use for `RGB` values. Defaults to `1.0`
    ///   - opacity: Opacity value. Defaults to `1.0. `
    /// - Returns: A `Color` constructed from random `RGB` values.
    public static func random(
        rgbMin: Double = 0.0,
        rgbMax: Double = 1.0,
        opacity: Double = 1.0
    ) -> Color {
        random(
            red: rgbMin...rgbMax,
            green: rgbMin...rgbMax,
            blue: rgbMin...rgbMax,
            opacity: opacity
        )
    }
    
    /// Generates a Color using random RGB values.
    /// - Parameters:
    ///   - redRange: The range to use when generating random value for red. Defaults to `0.0...1.0`
    ///   - greenRange: The range to use when generating random value for green. Defaults to `0.0...1.0`
    ///   - blueRange: The range to use when generating random value for blue. Defaults to `0.0...1.0`
    ///   - opacity: Opacity value. Defaults to `1.0. `
    /// - Returns: A `Color` constructed from random `RGB` values.
    public static func random(
        red redRange: ClosedRange<Double> = 0.0...1.0,
        green greenRange: ClosedRange<Double> = 0.0...1.0,
        blue blueRange: ClosedRange<Double> = 0.0...1.0,
        opacity: Double = 1.0
    ) -> Color {
        Color(
            red: .random(in: redRange),
            green: .random(in: greenRange),
            blue: .random(in: blueRange),
            opacity: opacity
        )
    }

    /// Generates a Color using random HSB values.
    /// - Parameters:
    ///   - hueRange: The range to use when generating random value for hue. Defaults to `0.0...1.0`
    ///   - saturationRange: The range to use when generating random value for saturation. Defaults to `0.0...1.0`
    ///   - brightnessRange: The range to use when generating random value for brightness. Defaults to `0.0...1.0`
    ///   - opacity: Opacity value. Defaults to `1.0. `
    /// - Returns: A `Color` constructed from random `HSB` values.
    public static func random(
        hue hueRange: ClosedRange<Double> = 0.0...1.0,
        saturation saturationRange: ClosedRange<Double> = 0.0...1.0,
        brightness brightnessRange: ClosedRange<Double> = 0.0...1.0,
        opacity: Double = 1.0
    ) -> Color {
        Color(
            hue: .random(in: hueRange),
            saturation: .random(in: saturationRange),
            brightness: .random(in: brightnessRange),
            opacity: opacity
        )
    }
    
    public static func randomHue(
        saturation: Double = 1.0,
        brightness: Double = 1.0,
        opactity: Double = 1.0
    ) -> Color {
        Color.random(
            //            hue: <#T##ClosedRange<Double>#>,
            saturation: saturation...saturation,
            brightness: brightness...brightness,
            opacity: opactity
        )
    }
}

