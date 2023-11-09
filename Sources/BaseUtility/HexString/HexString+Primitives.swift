//
//  HexString.swift
//  Nightlight
//
//  Created by Zakk Hoyt on 8/26/16.
//  Copyright © 2016 Zakk Hoyt. All rights reserved.
//

import Foundation

extension Bool {
    public var boolString: String {
        self == true ? "true" : "false"
    }
    
    public var binaryString: String {
        self == true ? "0b00000001" : "0b00000000"
    }
    
    public var hexString: String {
        self == true ? "0x01" : "0x00"
    }
}

private let bitsPerByte = 8
extension FixedWidthInteger {
    public var byteWidth: Int {
        bitWidth / 8
    }

//    public var binaryString: String {
//        let binaryString = String(self, radix: 2)
//        let isNegative = binaryString.prefix(1) == "-"
//        var toAdd: Int = MemoryLayout<Self>.size * 8 - binaryString.count
//        if toAdd < 0 { toAdd = 0 }
//        var padded = binaryString.replacingOccurrences(of: "-", with: "") // input may have - sign
//        for _ in 0..<toAdd {
//            padded = "0" + padded
//        }
//        let prefix = isNegative ? "-" : ""
//        return "\(prefix)0b\(padded)"
//    }
    public var binaryString: String {
        "0b" + (0..<(Self.bitWidth / 8)).reduce(into: []) {
            let byteString = String(
                UInt8(truncatingIfNeeded: self >> ($1 * 8)),
                radix: 2
            )
            let padding = String(
                repeating: "0",
                count: 8 - byteString.count
            )
            $0.append(padding + byteString)
        }.reversed().joined(separator: "")
    }
}



extension BinaryInteger {
    
}
extension FixedWidthInteger {
    public var hexString: String {
        let hexString = String(self, radix: 16)
        return "0x" + (0..<Swift.max(0, MemoryLayout<Self>.size * 2 - hexString.count)).reduce(into: hexString.replacingOccurrences(of: "-", with: "")) {  partialResult, i in
            partialResult = "0" + partialResult
        }.uppercased()
    }
}





extension FixedWidthInteger {
    public var percentString: String {
        let percent = Float(self) / Float(Self.max) * 100
        return String(format: "%.0f%%", percent)
    }
}


extension FixedWidthInteger {
    /// Easy way to return a percentage of an Int type.
    public static func fractionOfMax(percent: Float) -> Self { Self((Float(Self.max) * percent).rounded()) }
}

//
//extension Result {
//    /// Expresses `Result` as a `Bool`.
//    public var successful: Bool {
//        switch self {
//        case .success: return true
//        case .failure: return false
//        }
//    }
//}
//
