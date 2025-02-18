//
// Clip.swift
// ColorPicKitExample
//
// Created by Zakk Hoyt on 11/4/16.
// Copyright © 2016 Zakk Hoyt. All rights reserved.
//

import CoreGraphics

#warning("FIXME: zakkhoyt - move these to protocols")
func clip(_ value: CGFloat) -> CGFloat {
    max(0.0, min(1.0, value))
}

func closeEnough(value: CGFloat, expected: CGFloat, tolerance: CGFloat = 0.01) -> Bool {
    let min = clip(expected - tolerance)
    let max = clip(expected + tolerance)
    return min <= value && value <= max
}

func by360(_ value: CGFloat) -> CGFloat {
    value / 360.0
}

func by255(_ value: CGFloat) -> CGFloat {
    value / 255.0
}

func by100(_ value: CGFloat) -> CGFloat {
    value / 100.0
}
