//
//  Comments.swift
//
//  Created by Zakk Hoyt on 10/22/21.
//
//  https://developer.apple.com/library/archive/documentation/Xcode/Reference/xcode_markup_formatting_ref/MarkupSyntax.html

#if os(macOS)

import Foundation

enum Comment {
    //: [Next Topic](@next)

    /// Testing Xcode markdown stuff. More text. <br /> A new line?
    ///
    /// Here is even more
    /// - Parameters:
    ///   - param1: A `String` params
    ///   - param2: An `Int` param
    /// - Returns: A precision string.
    static func commentsA(
        param1: String,
        param2: Int
    ) throws -> String {
        String(floatString: 3.445, fidelity: 2)
    }
}

#endif
