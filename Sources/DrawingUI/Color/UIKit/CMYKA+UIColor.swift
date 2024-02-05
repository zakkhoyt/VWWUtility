//
//  CMYKA+UIColor.swift
//
//  Created by Zakk Hoyt on 6/24/23.
//

#if os(iOS)
import UIKit

extension CMYKA {
    public func color() -> UIColor {
        rgba.color()
    }
    
    // MARK: Static functions
    
    public static func colorWith(cmyka: CMYKA) -> UIColor {
        cmyka.color()
    }
}

extension UIColor {
    // MARK: UIColor to Color struct
    
    public func cmyka() -> CMYKA {
        rgba().cmyka
    }
    
    // MARK: UIColor inits and constructors
    
    public convenience init(cmyka: CMYKA, alpha: CGFloat = 1.0) {
        let rgba = cmyka.rgba
        self.init(red: rgba.red, green: rgba.green, blue: rgba.blue, alpha: rgba.alpha)
    }
    
    public class func colorWith(cmyka: CMYKA) -> UIColor {
        cmyka.color()
    }
}

extension UIImage {
    public func cmykaPixels() -> [CMYKA] {
        var pixels = [CMYKA]()
        for rgba in rgbaPixels() {
            let cmyka = rgba.cmyka
            pixels.append(cmyka)
        }
        return pixels
    }
}

#endif
