//
//  HexString+Data.swift
//
//  Created by Zakk Hoyt on 7/15/23.
//

import Foundation

extension Data {
    /// Returns `self` as `[UInt8]` (an array of bytes)
    public var bytes: [UInt8] {
        var bytes = [UInt8](repeating: 0, count: count)
        copyBytes(to: &bytes, count: count)
        return bytes
    }
}

extension Data {
    /// Converts `bytes` to a single `String` represented in base 16 (hex) notation
    /// with or without the  `"0x"` prefix
    ///
    /// - Parameter includePrefix: If true, return value will be prepended with
    /// `"0x"`. Otherwise no prefix.
    ///
    /// ## Example
    ///
    /// ```swift
    /// [UInt8(0xFF), UInt8(80)].hexString() == "0xFF80"
    /// [UInt8(0xFF), UInt8(80)].hexString(includePrefix: true) == "0xFF80"
    /// [UInt8(0xFF), UInt8(80)].hexString(includePrefix: false) == "FF80"
    /// ```
    public func hexString(
        includePrefix: Bool = true
    ) -> String {
        bytes.hexString(includePrefix: includePrefix)
    }
    
    /// Converts `bytes` elements to a single `String` represented in base 16 (hex) notation
    /// with the  `"0x"` prefix
    ///
    /// ## Example
    /// ```swift
    /// [UInt8(0xFF), UInt8(80)].hexString == "0xFF80"
    /// ```
    ///
    /// - SeeAlso: `Array/hexString(includePrefix:)`
    public var hexString: String {
        bytes.hexString
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

public enum DataUnpackingError: LocalizedError {
    case dataTooSmallForFixedWidthInteger(actualSize: Int, expectedSize: Int, type: String)
    
    public var errorDescription: String? {
        switch self {
        case .dataTooSmallForFixedWidthInteger(let actualSize, let expectedSize, let type):
            "In order to cast Data to \(type), it must be at least \(expectedSize) bytes long. \(actualSize) bytes were found"
        }
    }
}

extension Data {
    /// Converts `self` to any `FixedWidthInteger` type
    ///
    /// - Throws:`DataUnpackingError` if `T.size != data.count`. This helps to avoid
    /// a runtime crash
    public func swapAndUnpack<T: FixedWidthInteger>() throws -> T {
        guard count >= MemoryLayout<T>.size else {
            throw DataUnpackingError.dataTooSmallForFixedWidthInteger(
                actualSize: count,
                expectedSize: MemoryLayout<T>.size,
                type: "\(T.self)"
            )
        }
        let mdata = self
        return mdata.withUnsafeBytes { $0.load(as: T.self).byteSwapped }
    }
}

extension Data {
    /// Coverts a hexString flavored `String` into`Data` via `[UInt8]`
    ///
    /// - Remark: This function will reduce `hexString` down to hex characters only before processing.
    ///
    /// ## References
    /// * [StackOverflow](https://stackoverflow.com/questions/26501276/converting-hex-string-to-nsdata-in-swift)
    public init(hexString: String) {
        var hex = Radix.hexadecimal.dataString(from: hexString)
        var data = Data()
        while !hex.isEmpty {
            let subIndex = hex.index(hex.startIndex, offsetBy: Swift.min(2, hex.count))
            let c = String(hex[..<subIndex])
            hex = String(hex[subIndex...])
            var ch: UInt64 = 0
            Scanner(string: c).scanHexInt64(&ch)
            var char = UInt8(ch)
            data.append(&char, count: 1)
        }
        self = data
    }
}
