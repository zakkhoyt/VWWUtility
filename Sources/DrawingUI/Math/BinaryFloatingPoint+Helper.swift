//
//  BinaryFloatingPoint+Helper.swift
//  WaveSynthesizer-iOS
//
//  Created by Zakk Hoyt on 6/23/19.
//  Copyright © 2019 Zakk Hoyt. All rights reserved.
//

import Foundation

extension BinaryInteger {
    @available(*, unavailable, message: "Use Double(self)")
    public var d: Double {
        Double(self)
    }
    
    @available(*, unavailable, message: "Use Float(self)")
    public var f: Float {
        Float(self)
    }
}
