//
//  HSLA+UIColor.swift
//
//  Created by Zakk Hoyt on 6/24/23.
//

#if os(iOS)
import UIKit

extension HSLA {
    public func color() -> UIColor {
        let color = UIColor(rgba: rgba)
        return color
    }

    // MARK: Static functions

    public static func colorWith(hsla: HSLA) -> UIColor {
        hsla.color()
    }
}

extension UIColor {
    // MARK: UIColor to Color struct

    public func hsla(alpha: CGFloat = 1.0) -> HSLA {
        rgba().hsla
    }

    // MARK: UIColor inits and constructors

    public convenience init(hsla: HSLA, alpha: CGFloat = 1.0) {
        let rgba = hsla.rgba
        self.init(red: rgba.red, green: rgba.green, blue: rgba.blue, alpha: rgba.alpha)
    }

    public class func colorWith(hsla: HSLA) -> UIColor {
        hsla.color()
    }
}

extension UIImage {
    public func hslaPixels() -> [HSLA] {
        var pixels = [HSLA]()
        for rgba in rgbaPixels() {
            let hsla = rgba.hsla
            pixels.append(hsla)
        }
        return pixels
    }
}

#endif
