//
//  YUVA+UIColor.swift
//
//  Created by Zakk Hoyt on 6/24/23.
//

#if os(iOS)
import UIKit

extension YUVA {
    public func color() -> UIColor {
        rgba.color()
    }

    // MARK: Static functions

    public static func colorWith(yuva: YUVA) -> UIColor {
        yuva.color()
    }
}

extension UIColor {
    // MARK: UIColor to Color struct
    
    public func yuva(alpha: CGFloat = 1.0) -> YUVA {
        var yuva = rgba().yuva
        yuva.alpha = alpha
        return yuva
    }
    
    // MARK: UIColor inits and constructors
    
    public convenience init(yuva: YUVA, alpha: CGFloat = 1.0) {
        let rgba = yuva.rgba
        self.init(red: rgba.red, green: rgba.green, blue: rgba.blue, alpha: alpha)
    }
    
    public class func colorWith(yuva: YUVA) -> UIColor {
        yuva.color()
    }
}

extension UIImage {
    public func yuvaPixels() -> [YUVA] {
        var pixels = [YUVA]()
        for rgba in rgbaPixels() {
            let yuva = rgba.yuva
            pixels.append(yuva)
        }
        return pixels
    }
}

#endif
