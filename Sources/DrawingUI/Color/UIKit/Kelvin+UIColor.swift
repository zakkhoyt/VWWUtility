//
// Kelvin+UIColor.swift
//
// Created by Zakk Hoyt on 6/24/23.
//

#if os(iOS)
import UIKit

extension Kelvin {
    public var color: UIColor {
        rgba.color()
    }
    
    // MARK: Static functions
    
    public static func colorWith(kelvin: Kelvin) -> UIColor {
        kelvin.rgba.color()
    }
}

extension UIColor {
    // MARK: UIColor to Color struct
    
    //    /// Unlike the other color formats, there is no function to convert any color to kelvin as
    //    /// kelvin is a subset of all colors like RGB.
    //    public func kelvin(alpha: CGFloat = 1.0) -> kelvin {}
    
    // MARK: UIColor inits and constructors
    
    public convenience init(kelvin: CGFloat, alpha: CGFloat = 1.0) {
        let rgba = Kelvin(degrees: kelvin).rgba
        self.init(red: rgba.red, green: rgba.green, blue: rgba.blue, alpha: alpha)
    }
    
    public class func colorWith(kelvin: Kelvin) -> UIColor {
        kelvin.rgba.color()
    }
}

extension UIImage {
    //    /// Unlike the other color formats, there is no function to convert any color to kelvin as
    //    /// kelvin is a subset of all colors like RGB.
    //    public func kelvinPixels() -> [Kelvin] {}
}

#endif
