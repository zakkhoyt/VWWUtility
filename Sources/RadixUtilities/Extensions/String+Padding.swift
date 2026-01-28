//
//  String+Padding.swift
//
//  Created by Zakk Hoyt on 1/31/24.
//

import Foundation


#warning(
    """
    TODO: zakkhoyt AI - Replace this file with near duplicate
    at: Sources/BaseUtility/Extensions/String+Padding.swift
    which has `func padded` vs this `func padding`
    """
)
extension String {
    public enum EndFix {
        case prefix
        case suffix
    }
    
    /// Pads a `String` to be a certain length
    ///
    /// - Parameters:
    ///   - length: Final string length.
    ///   - character: The character to use for padding.
    ///   - endfix: Where to affix the padding characters
    /// - Returns: A padded version of `self`.
    public func padding(
        length: any FixedWidthInteger,
        character: Character = " ",
        endfix: EndFix = .prefix
    ) -> String {
        let padding = String(
            repeating: character,
            count: max(0, Int(length) - count)
        )
        switch endfix {
        case .prefix: return "\(padding)\(self)"
        case .suffix: return "\(self)\(padding)"
        }
    }

    /// Pads a `self` to be a certain length (mutating)
    ///
    /// - Remark: `mutating` version of padding
    /// - Parameters:
    ///   - length: Final string length.
    ///   - character: The character to use for padding.
    ///   - endfix: Where to affix the padding characters
    public mutating func pad(
        length: Int,
        character: Character = " ",
        endfix: EndFix = .prefix
    ) {
        self = padding(length: length, character: character, endfix: endfix)
    }
}
