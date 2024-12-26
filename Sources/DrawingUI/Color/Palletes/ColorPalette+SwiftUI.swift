//
//  ColorPalette.swift
//  VWWUtility
//
//  Created by Zakk Hoyt on 2024-12-24.
//

import SwiftUI

extension ColorPalette {
    public var gradientStops: [Gradient.Stop] {
        keyColors.map {
            Gradient.Stop(color: $0.color, location: $0.offset)
        }
    }
}
