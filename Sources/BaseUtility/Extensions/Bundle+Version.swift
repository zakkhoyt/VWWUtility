//
//  Bundle+Version.swift
//
//
//  Created by Zakk Hoyt on 12/4/23.
//

import Foundation

extension Bundle {
    public var appName: String? {
        guard let value = object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String else {
            return nil
        }
        return value
    }
    
    public var versionString: String? {
        guard let value = object(forInfoDictionaryKey: "CFBundleShortVersionString" as String) as? String else {
            return nil
        }
        return value
    }
    
    public var buildString: String? {
        guard let value = object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String else {
            return nil
        }
        return value
    }
    
    public var versionAndBuildString: String? {
        guard let versionString,
              let buildString else {
            return nil
        }
        return "\(versionString) b\(buildString)"
    }
}
