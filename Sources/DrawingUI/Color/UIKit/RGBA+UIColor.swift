//
// RGBA+UIColor.swift
//
// Created by Zakk Hoyt on 6/24/23.
//

#if os(iOS)
import UIKit

extension RGBA {
    public func color() -> UIColor {
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    // MARK: Static functions
    
    public static func colorWith(rgba: RGBA) -> UIColor {
        rgba.color()
    }
}

extension UIColor {
    // MARK: UIColor to Color struct
    
    public func rgba(alpha: CGFloat = 1.0) -> RGBA {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return RGBA(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    // MARK: UIColor inits and constructors
    
    public convenience init(rgba: RGBA, alpha: CGFloat = 1.0) {
        self.init(red: rgba.red, green: rgba.green, blue: rgba.blue, alpha: rgba.alpha)
    }
    
    public class func colorWith(rgba: RGBA) -> UIColor {
        rgba.color()
    }
}

extension UIImage {
    public func rgbaPixels() -> [RGBA] {
        let pixelData = cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let length = CFDataGetLength(pixelData)
        let bytesPerRow = Int(length / Int(size.height))
        
        var pixels = [RGBA]()
        for y in 0..<Int(size.width) {
            for x in 0..<Int(size.height) {
                let index = y * bytesPerRow + x * 4
                
                if index < 0 {
                    print("Error: index out of bounds")
                    break
                } else if index > Int(Int(size.width) * Int(size.height) * 4) {
                    print("Error: index out of bounds")
                    break
                }
                
                //        print("w:\(Int(size.width)) h:\(Int(size.height))")
                //        print("x:\(Int(point.x)) y:\(Int(point.y)) index:\(index)")
                let blue = CGFloat(data[index]) / CGFloat(255.0)
                let green = CGFloat(data[index + 1]) / CGFloat(255.0)
                let red = CGFloat(data[index + 2]) / CGFloat(255.0)
                let alpha = CGFloat(data[index + 3]) / CGFloat(255.0)
                
                let rgba = RGBA(red: red, green: green, blue: blue, alpha: alpha)
                pixels.append(rgba)
            }
        }
        
        return pixels
    }
}

extension UIColor {
    // MARK: Additional helper functions
        
    /// Convenience propety to determine if a custom color has set a value its color channels or its defaulted to RBG (0, 0, 0)
    public var isBlack: Bool {
        let rgb = rgba()
        return rgb.red.isZero && rgb.green.isZero && rgb.blue.isZero
    }
        
    /// Create a UIColor with a hex string
    ///
    /// - parameter rgbwHexString: RRGGBBWW or #RRGGBBWW
    /// - parameter alpha:     An alpha value from 0.0 to 1.0
    ///
    /// - returns: UIColor instance
    public convenience init(rbgwHexString: String, alpha: CGFloat = 1.0) {
        let color = rbgwHexString.hexStringValue
            
        let mask = 0x000000FF
        let r = Int(color >> 24) & mask
        let g = Int(color >> 16) & mask
        let b = Int(color >> 8) & mask
        let w = Int(color) & mask
            
        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        let white = CGFloat(w) / 255.0
            
        // Currently checking if white is `1` to be able to render the white color correctly.
        if white.isEqual(to: 1) {
            self.init(white: white, alpha: alpha)
        } else {
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        }
    }
}

#endif
