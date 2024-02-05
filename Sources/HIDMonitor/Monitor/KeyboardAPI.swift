//
//  KeyboardAPI.swift
//  HotkeyDecorator
//
//  Created by Zakk Hoyt on 1/22/24.
//

import Foundation
import SwiftUI

public protocol KeyboardKeyRepresentable {
    var symbol: String { get }
    var symbolName: String { get }
//    var image: Image { get }
}

extension KeyboardKeyRepresentable {
    public var image: Image {
        Image(symbolName, bundle: nil)
    }
}
