//
//  NativeColor.swift
//  VWWUtility
//
//  Created by Zakk Hoyt on 2024-12-24.
//


#if canImport(AppKit)
    import AppKit
#elseif canImport(UIKit)
    import UIKit
#endif

#if canImport(UIKit)
typealias NativeColor = UIColor
#elseif canImport(AppKit)
typealias NativeColor = NSColor
#endif

import SwiftUI

extension Color {
    var nativeColor: NativeColor {
        NativeColor(self)
    }
}


extension NativeColor {
#warning("""
FIXME: zakkhoyt - This is written this way 
to avoide collision with the function below
* Replace all mentions of `UIColor` with `NativeColor` in this package.
* Then delete this function and rename _rgba to match the others
""")
    public static func rgba(color: Color) -> RGBA {
        color.nativeColor._rgba()
    }
    
    private func _rgba(alpha: CGFloat = 1.0) -> RGBA {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        
#warning("""
FIXME: zakkhoyt - ColorPaletteView: (fft heatmap): apply colorPalette for stroke color here
* macOS has real performance lag working wtih Colors on this thread. iOS seems more tolerant. 
* this is significant with SwiftUI's Color (rgba) as well as NSColor's getRedGreenBlue and colorspaces
""")
        

        
        
#if canImport(UIKit)
//        typealias NativeColor = UIColor
#elseif canImport(AppKit)
//        typealias NativeColor = NSColor
//        colorUsingColorSpace
//        self.usingColorSpace(.deviceRGB)?.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
#endif

        
        
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return RGBA(red: red, green: green, blue: blue, alpha: alpha)
    }
}
