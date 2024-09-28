//
//  HexString+Primitives.swift
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

private let bitsPerByte = UInt8.bitWidth
extension FixedWidthInteger {
    public var binaryString: String {
        // "0b" + (0..<(Self.bitWidth / 8)).reduce(into: []) {
        "0b" + (0..<(Self.byteWidth)).reduce(into: []) {
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

extension BinaryInteger {}

extension FixedWidthInteger {
    public var hexString: String {
        let hexString = String(self, radix: 16)
        return "0x" + (0..<Swift.max(0, MemoryLayout<Self>.size * 2 - hexString.count))
            .reduce(
                into: hexString.replacingOccurrences(of: "-", with: "")
            ) { partialResult, _ in
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
// extension Result {
//    /// Expresses `Result` as a `Bool`.
//    public var successful: Bool {
//        switch self {
//        case .success: return true
//        case .failure: return false
//        }
//    }
// }
//

extension Unicode {
    public static func printTable() {
        (UInt8.min...UInt8.max).forEach { item in
//        for item in UInt8.min...UInt8.max {
            print(
                [
                    "\(item)",
                    String(format: "%02X", item),
                    item.binaryString,
                    Unicode.Scalar(item).escaped(asASCII: true)
                ].joined(separator: "\t")
            )
        }
    }
}
