//
// HexString+Data.swift
//
// Created by Zakk Hoyt on 7/15/23.
//

import Foundation

extension Data {
    public func hexEncodedString() -> String {
        map { String(format: "%02hhX", $0) }.joined()
    }
    
    public var bytes: [UInt8] {
        var bytes = [UInt8](repeating: 0, count: count)
        copyBytes(to: &bytes, count: count)
        return bytes
    }
}

extension Data {
    public var hexString: String {
        "0x" + map { String(format: "%02hhX", $0) }.joined()
    }
}

extension StringProtocol {
    public var data: Data { Data(byteSequence) }
    public var bytes: [UInt8] { [UInt8](byteSequence) }
    
    private var byteSequence: UnfoldSequence<UInt8, Index> {
        sequence(state: startIndex) { i in
            guard i < self.endIndex else { return nil }
            let endIndex = self.index(i, offsetBy: 2, limitedBy: self.endIndex) ?? self.endIndex
            defer { i = endIndex }
            return UInt8(self[i..<endIndex], radix: 16)
        }
    }
}

extension Data {
    public func swapAndUnpack<T: FixedWidthInteger>() -> T {
        let mdata = self
        return mdata.withUnsafeBytes { $0.load(as: T.self).byteSwapped }
    }
}
