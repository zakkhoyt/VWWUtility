//
//  HSBA+Color.swift
//  VWWUtility
//
//  Created by Zakk Hoyt on 2024-12-24.
//

import SwiftUI

extension Color {
    /// Interpolates between `color1` and `color2` using `portion` which
    /// is a `Double` in `0.0...1.0`
    public static func interpolate(
        portion: Double,
        color1: Color,
        color2: Color
    ) -> Color {
        let rgba = RGBA.interpolate(
            portion: portion,
            rgba1: color1.rgba,
            rgba2: color2.rgba,
            includeAlpha: false
        )
        
#if canImport(UIKit)
        if #available(iOS 17.0, *) {
            return Color(
                Resolved(
                    red: Float(rgba.red),
                    green: Float(rgba.green),
                    blue: Float(rgba.blue)
                )
            )
        } else {
            // Fallback on earlier versions
            return .blue
        }
        //
#elseif canImport(AppKit)
        return Color(
            Resolved(
                red: Float(rgba.red),
                green: Float(rgba.green),
                blue: Float(rgba.blue)
            )
        )
#endif
    }
}

extension Color {
    public var rgba: RGBA {
        @Environment(\.self) var environment
        if #available(macOS 14.0, iOS 17.0, *) {
            let resolved = resolve(in: environment)
            return RGBA(
                red: Double(resolved.linearRed),
                green: Double(resolved.linearGreen),
                blue: Double(resolved.linearBlue),
                alpha: Double(resolved.opacity)
            )

        } else {
            return NativeColor.rgba(color: self)
        }
    }
}
