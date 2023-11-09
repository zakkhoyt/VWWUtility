//
//  String+HexString.swift
//
//  Created by Zakk Hoyt on 7/14/23.
//

import Foundation

extension String {
    var hexStringValue: UInt32 {
        let scanner = Scanner(string: self)
        scanner.charactersToBeSkipped = CharacterSet(arrayLiteral: "#")
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        return UInt32(color)
    }
}
