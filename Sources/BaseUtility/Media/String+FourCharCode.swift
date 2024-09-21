//
//  String+FourCharCode.swift
//  VWWUtility
//
//  Created by Zakk Hoyt on 2024-09-21.
//

import CoreFoundation
import Foundation

extension FourCharCode {
    public enum Error: LocalizedError {
        case invalidStringLength(String)
        case invalidCharacterTypes(String)
        
        public var errorDescription: String? {
            switch self {
            case .invalidStringLength(let string):
                "Creating a FourCharCode from a String requires a character count of 4. Expected: 4. Actual: \(string.count) (\(string))"
            case .invalidCharacterTypes(let string):
                "Creating a FourCharCode from a String requires it to be composed of exactly 4 characters of type .utf8. Found other character formats in (\(string))"
            }
        }
    }
}

extension String {
#warning("FIXME: zakkhoyt - Remove after testing new impl")
//    var fourCharCode: FourCharCode? {
//        guard self.count == 4 && self.utf8.count == 4 else {
//            return nil
//        }
//        
//        var code: FourCharCode = 0
//        for character in self.utf8 {
//            code = code << 8 + FourCharCode(character)
//        }
//        return code
//    }

    /// Construct `CoreFoundation.FourCharCode` from a `String` of compatible value
    ///
    /// - Precondition: `self.count == 4`
    ///
    /// ## Example
    ///
    /// ```swift
    /// guard let fcc: FourCharCode = "vide".fourCharCode else { return }
    /// guard let fcc: FourCharCode = "fmt?".fourCharCode else { return }
    /// ```
    ///
    public var fourCharCode: FourCharCode {
        get throws {
            guard self.count == 4 else {
                throw FourCharCode.Error.invalidStringLength(self)
            }
            guard self.utf8.count == 4 else {
                throw FourCharCode.Error.invalidCharacterTypes(self)
            }
            
//            return self.utf8.reduce(into: 0) {
//                $0 <<= 8 + FourCharCode($1)
//            }
            var code: FourCharCode = 0
            for character in self.utf8 {
                code = code << 8 + FourCharCode(character)
            }
            return code
        }
    }
}

extension FourCharCode {
    public var stringRepresentation: String {
        var unsignedStatus: UInt32 = self
        let bytes: [UInt8] = withUnsafePointer(to: &unsignedStatus) {
            let count = MemoryLayout<UInt32>.size / MemoryLayout<UInt8>.size
            let bytePtr = $0.withMemoryRebound(to: UInt8.self, capacity: count) {
                UnsafeBufferPointer(start: $0, count: count)
            }
            return [UInt8](bytePtr).reversed()
        }
        
        let characters: [Character] = bytes.compactMap {
            guard let scalar = Unicode.Scalar(UInt32($0)) else { return nil }
            return Character(scalar)
        }
        
        let string: String = characters.map { String($0) }.joined()
        return string
    }
}

