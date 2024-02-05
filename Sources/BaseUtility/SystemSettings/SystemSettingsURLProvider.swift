//
//  SystemSettingsURLProvider.swift
//
//  Created by Zakk Hoyt on 2/4/24.
//

import Foundation

public protocol SystemSettingsURLProvider: CaseIterable, RawRepresentable where RawValue == String {
    var url: URL { get }
    var appSpecificUrl: URL { get }
}

extension SystemSettingsURLProvider {
    public var url: URL {
        guard let appSpecificUrl = URL(string: "\(rawValue)") else {
            preconditionFailure("Must be able to get app settings url")
        }
        return appSpecificUrl
        
    }
    
    public var appSpecificUrl: URL {
        guard let bundleId = Bundle.main.bundleIdentifier,
              let appSpecificUrl = URL(string: "\(self.rawValue)/\(bundleId)")
        else {
            preconditionFailure("Must be able to get app settings url")
        }
        
        return appSpecificUrl
    }
}
