//
// String+Padding.swift
//
// Created by Zakk Hoyt on 1/31/24.
//

import Foundation

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
    public func padded(
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
    
    public mutating
    func pad(
        length: Int,
        character: Character = " ",
        endfix: EndFix = .prefix
    ) {
        self = padded(length: length, character: character, endfix: endfix)
    }
}
