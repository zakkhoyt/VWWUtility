//
//  SystemSettingsURLProvider.swift
//
//  Created by Zakk Hoyt on 2/4/24.
//

import Foundation

public protocol SystemSettingsURLParticipant {
    @MainActor
    static func open(
        _ provider: any SystemSettingsURLProvider,
        appSpecific: Bool
    )
    
    static var categories: [
        any SystemSettingsURLProvider.Type
    ] { get }
}

public protocol SystemSettingsURLProvider: CaseIterable, RawRepresentable where RawValue == String {
    var url: URL { get }
    var appSpecificUrl: URL { get }
}

extension SystemSettingsURLProvider {
    public var url: URL {
        guard let url = URL(string: "\(rawValue)") else {
            preconditionFailure("Must be able to get app settings url")
        }
        return url
    }
    
    public var appSpecificUrl: URL {
#if os(iOS)
        guard let bundleId = Bundle.main.bundleIdentifier,
              let appSpecificUrl = URL(string: "\(rawValue)/\(bundleId)")
        else {
            preconditionFailure("Must be able to get app settings url")
        }
        return appSpecificUrl
#elseif os(macOS)
    
        #warning("TODO: zakkhoyt - App specific URLs doen't work the same for macOS. Research and document.")
        return url
#endif
    }
}
