//
//  DoccSandboxTests.swift
//  DoccSandboxTests
//
//  Created by Zakk Hoyt on 2024-11-25.
//

import Foundation
@testable import DoccSandbox

import UIKit






import Testing

@Suite("placehold.co API")
struct PlaceholdTests {
    @Test(
        """
        Full permutation of Font.allCases and Format.allCases.
        Complexity: O(n^2) 
        """,
        .serialized,
        arguments: Placehold.Font.allCases,
        Placehold.Format.allCases
    )
    func testFontFormatPermutation(
        font: Placehold.Font,
        format: Placehold.Format
    ) async throws {
        let url = try #require(
            Placehold.url(
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
        
        try await DoccSandbox.URLOpener.open(url: url)
    }
}
    
    
//    @Test(
//        "Test all fonts",
//        .serialized,
//        arguments: Placehold.Font.allCases
//    )
//    func testFonts(font: Placehold.Font) async throws {
//        let url = try #require(
//            Placehold.url(
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
//        arguments: Placehold.Format.allCases
//    )
//    func testFormats(format: Placehold.Format) async throws {
//        let url = try #require(
//            Placehold.url(
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
