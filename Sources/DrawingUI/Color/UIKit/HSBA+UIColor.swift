//
// HSBA+UIColor.swift
//
// Created by Zakk Hoyt on 6/24/23.
//

#if os(iOS)
import UIKit

extension HSBA {
    public func color() -> UIColor {
        let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
        return color
    }

    // MARK: Static functions

    public static func colorWith(hsba: HSBA) -> UIColor {
        hsba.color()
    }
}

extension UIColor {
    // MARK: UIColor to Color struct

    public func hsba(alpha: CGFloat = 1.0) -> HSBA {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return HSBA(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    // MARK: UIColor inits and constructors

    public convenience init(hsba: HSBA, alpha: CGFloat = 1.0) {
        self.init(hue: hsba.hue, saturation: hsba.saturation, brightness: hsba.brightness, alpha: hsba.alpha)
    }

    public class func colorWith(hsba: HSBA) -> UIColor {
        hsba.color()
    }
}

extension UIImage {
    public func hsbaPixels() -> [HSBA] {
        var pixels = [HSBA]()
        for rgba in rgbaPixels() {
            let hsba = rgba.hsba
            pixels.append(hsba)
        }
        return pixels
    }
}

#endif
