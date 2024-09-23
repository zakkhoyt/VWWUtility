//
// HexString+Collections.swift
//
//
// Created by Zakk Hoyt on 7/27/23.
//

import Foundation

extension Array where Element: FixedWidthInteger {
    public var hexString: String {
        "0x" + map { $0.hexString }
            .joined()
    }
}
