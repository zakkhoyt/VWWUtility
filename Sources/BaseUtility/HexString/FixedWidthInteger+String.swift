//
//  FixedWidthInteger+String.swift
//
//
//  Created by Zakk Hoyt on 1/28/24.
//

import Foundation

extension FixedWidthInteger {
    public init?(hexString: String) {
        let cleanString: String = {
            guard hexString.hasPrefix("0x") else { return hexString }
            return hexString.replacingOccurrences(of: "0x", with: "")
        }()
        self.init(cleanString, radix: 16)
    }
}

#warning("FIXME: zakkhoyt - Convert this to tests for the above")
//func test<T: FixedWidthInteger>(
//    type: T.Type,
//    hexString: String
//) -> T? {
//    let v = T(hexString: hexString)
//    print("--- Type: \(type)")
//    print("hexString: \(hexString), v: \(v?.string ?? "<nil>")")
//    return v
//}
//
//let types: [any FixedWidthInteger.Type] = [
//    UInt8.self,
//    UInt16.self,
//    UInt32.self,
//    UInt64.self,
//    Int8.self,
//    Int16.self,
//    Int32.self,
//    Int64.self
//]
//
//let hexStrings = [
//    "0x7F",
//    "0xFF",
//    "0xFF00",
//    "0xFF000000",
//    "0xFF00000000000000"
//]
//
//for hexString in hexStrings {
//    for type in types {
//        let r = test(
//            type: type,
//            hexString: hexString
//        )
//        print("r: \(r?.string ?? "<nil>")")
//    }
//}



extension String {
    public init?(ifNotNil value: (any FixedWidthInteger)?) {
        guard let value = value else { return nil }
        self = "\(value)"
    }
}

extension FixedWidthInteger {
    public var string: String? {
        String(ifNotNil: self)
    }
}
