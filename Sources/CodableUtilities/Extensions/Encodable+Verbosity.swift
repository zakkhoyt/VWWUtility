//
//  Encodable+Verbosity.swift
//
//  Created by Scott Marchant on 8/4/22.
//

import Foundation

// MARK: - Encoding Verbosity -

extension CodingUserInfoKey {
    /// A dictionary key intended to be used in `JSONEncoder().userInfo`
    public static let verboseKey: CodingUserInfoKey? = {
        let rawValue = "verbose"
        guard let key = CodingUserInfoKey(rawValue: rawValue) else {
            logger.fault("Failed to create CodingUserInfoKey from rawValue: \(rawValue)")
            return nil
        }
        return key
    }()
    
    /// A value to pass into `userInfo` under  the`verboseKey` key.
    public enum Verbosity {
        case normal
        case verbose
    }
}

extension Encoder {
    /// Checks if `userInfo` contains a specific key/value pair which expresses verbose encoding.
    public var verboseEncoding: Bool {
        guard let verboseKey = CodingUserInfoKey.verboseKey,
              let verboseValue = userInfo[verboseKey] as? CodingUserInfoKey.Verbosity else {
            return false
        }
        return verboseValue == .verbose
    }
    
    /// Checks if `userInfo` contains a specific key/value pair which expreses normal encoding.
    public var normalEncoding: Bool {
        guard let verboseKey = CodingUserInfoKey.verboseKey,
              let verboseValue = userInfo[verboseKey] as? CodingUserInfoKey.Verbosity else {
            return false
        }
        return verboseValue == .normal
    }
}

extension JSONEncoder {
    /// Sets a key/value pair in userInfo to express that verbose encoding should be used.
    func setVerboseEncoding() {
        guard let verboseKey = CodingUserInfoKey.verboseKey else {
            return
        }
        userInfo[verboseKey] = CodingUserInfoKey.Verbosity.verbose
    }
}
