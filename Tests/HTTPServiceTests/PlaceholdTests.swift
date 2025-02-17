//
//  DoccSandboxTests.swift
//  DoccSandboxTests
//
//  Created by Zakk Hoyt on 2024-11-25.
//

import Foundation
@testable import HTTPServices
//import UIKit
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

import SwiftUI

import Testing

@Suite("placehold.co API")
struct PlaceholdTests {
    @Test(
        """
        Full permutation of Font.allCases and Format.allCases.
        Complexity: O(n^2) 
        """,
        .serialized,
//        arguments: HTTPServices.Placehold.Font.allCases,
        arguments: HTTPServices.Placehold.Font.allCases,
        HTTPServices.Placehold.Format.allCases
    )
    func testFontFormatPermutation(
        font: HTTPServices.Placehold.Font,
        format: HTTPServices.Placehold.Format
    ) async throws {
        let url = try #require(
            HTTPServices.Placehold.url(
                size: .init(width: 150, height: 150),
                backgroundColor: .red,
                foregroundColor: .cyan,
                format: format,
                text: [
                    format.description,
                    font.description
                ].joined(separator: "\n"),
                font: font
            )
        )
        
        print("""
            font: \(font.description) \
            format: \(format.description) \
            url: \(url.absoluteString)
        
        """)
        
//        try await URLOpener.open(url: url)
    }
}
    
//struct URLOpener {
//    enum Error: LocalizedError {
//        case failedToOpen(url: URL)
//        var errorDescription: String? {
//            switch self {
//            case .failedToOpen(url: let url):
//                return "Failed to open urL: \(url.absoluteString)"
//            }
//        }
//    }
//    
//    @MainActor
//    static func open(url: URL) async throws {
//        try await withCheckedThrowingContinuation { continuation in
//            UIApplication.shared.open(url) { success in
//                switch success {
//                case true:
//                    continuation.resume()
//                case false:
//                    continuation.resume(throwing: Error.failedToOpen(url: url))
//                }
//            }
//        }
//    }
//}

    
//    @Test(
//        "Test all fonts",
//        .serialized,
//        arguments: HTTPServices.Placehold.Font.allCases
//    )
//    func testFonts(font: HTTPServices.Placehold.Font) async throws {
//        let url = try #require(
//            HTTPServices.Placehold.url(
//                size: .init(width: 100, height: 150),
//                backgroundColor: .red,
//                foregroundColor: .green,
//                format: .svg,
//                text: font.description,
//                font: font
//            )
//        )
//        
//        try await DoccSandbox.URLOpener.open(url: url)
//    }
//    
//    @Test(
//        "Test all formats",
//        .serialized,
//        arguments: HTTPServices.Placehold.Format.allCases
//    )
//    func testFormats(format: HTTPServices.Placehold.Format) async throws {
//        let url = try #require(
//            HTTPServices.Placehold.url(
//                size: .init(width: 100, height: 150),
//                backgroundColor: .red,
//                foregroundColor: .green,
//                format: format,
//                text: format.description,
//                font: .playfairDisplay
//            )
//        )
//        
//        try await DoccSandbox.URLOpener.open(url: url)
//    }
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
