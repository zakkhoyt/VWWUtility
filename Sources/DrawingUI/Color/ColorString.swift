//
//  ColorString.swift
//
//  Created by Zakk Hoyt on 10/1/16.
//  Copyright © 2016 Zakk Hoyt. All rights reserved.
//

import CoreGraphics

public protocol ColorString {
    /// Returns a description in the format type specified.
    func stringFor(type: ColorStringType) -> String
}

public enum ColorStringType: Int {
    case baseOne
    case baseTen
    case baseSixteen

    public func string() -> String {
        switch self {
        case .baseSixteen:
            "0x00-0xFF"
        case .baseTen:
            "00-255"
        case .baseOne:
            "0.0-1.0"
        }
    }

    func format() -> String {
        switch self {
        case .baseOne:
            "%.02f"
        case .baseTen:
            "%03d"

        case .baseSixteen:
            "%02X"
        }
    }

    func factor() -> CGFloat {
        switch self {
        case .baseOne:
            1.0
        case .baseTen:
            255.0
        case .baseSixteen:
            255.0
        }
    }

    func formattedValue(value: CGFloat) -> Any {
        switch self {
        case .baseOne:
            Double(value * factor())
        case .baseTen:
            Int(value * factor())
        case .baseSixteen:
            Int(value * factor())
        }
    }
}

extension CGFloat {
    public var twoDigitHexString: String {
        let value = Int(self * 255)
        return String(format: "%02X", value)
    }
}
