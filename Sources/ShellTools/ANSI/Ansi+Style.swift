//
//  Ansi+Style.swift
//
//
//  Created by Zakk Hoyt on 6/9/24.
//

import Foundation

extension ANSI {
    public typealias Style = [ANSI]
    
    #warning("FIXME: zakkhoyt - rename?")
    public enum Group: CaseIterable, CustomStringConvertible, CustomDebugStringConvertible {
        case url
        case visitedURL
        case boldItalic
        case code
        case error
                
        public var ansis: [ANSI] {
            switch self {
            case .url: [.cyanForeground, .underlineFont]
            case .visitedURL: [.purpleForeground, .underlineFont]
            case .boldItalic: [.boldFont]
            case .code: [.yellowForeground, .boldFont]
            case .error: [.redForeground, .boldFont]
            }
        }
        
        public var description: String {
            switch self {
            case .url: "url"
            case .visitedURL: "visitedURL"
            case .boldItalic: "boldItalic"
            case .code: "code"
            case .error: "error"
            }
        }
        
        public var debugDescription: String {
            switch self {
            case .url: "A hyperlink. Cyan & underlined. EX: \(ANSI.UI.decorate(text: "https://ME.me", style: .url))"
            case .visitedURL: "A visited hyperlink. Purple. EX: \(ANSI.UI.decorate(text: "https://ME.me", style: .visitedURL))"
            case .boldItalic: "Bold. Oh, and Italic EX: \(ANSI.UI.decorate(text: "IMPORTANT", style: .boldItalic))"
            case .code: "The way code blocks are rendered. EX: \(ANSI.UI.decorate(text: "let (data, response) = try await apiService.slackWebhook()", style: .code))"
            case .error: "Errors need to grab attention. EX: \(ANSI.UI.decorate(text: "ERROR: Somethign went wrong", style: .error))"
            }
        }
    }
}

extension ANSI {
    public static let purpleForeground = ANSI.Item(.rgbForeground, values: [0x80, 0x00, 0x80]).ansi
}

extension [ANSI] {
    public static let url: ANSI.Style = [ANSI.underlineFont, ANSI.cyanForeground]
    
    #warning("FIXME: zakkhoyt - purple didn't work from picker menu")
    public static let visitedURL: ANSI.Style = [
        ANSI.underlineFont,
        // ANSI.Item(.rgbForeground, values: [0x80, 0x00, 0x80]).ansi
        .magentaForeground
    ]
    
    public static let boldItalic: ANSI.Style = [ANSI.boldFont, ANSI.italicFont]
    
    public static let code: [ANSI] = [.yellowForeground, .boldFont, .italicFont]
    
    public static let error: [ANSI] = [.redForeground, .boldFont, .italicFont]
    
    public static let warning: [ANSI] = [.orangeForeground, .boldFont, .italicFont]
}
