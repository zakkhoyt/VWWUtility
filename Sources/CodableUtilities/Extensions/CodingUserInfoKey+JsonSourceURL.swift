//
//  SwiftPackageJSONDecoder.swift
//  HatchTerminal
//
//  Created by Zakk Hoyt on 2025-01-16.
//
//  This file adds support for decoding JSON straight from json files on disk
//  as well as helpfu tools for analyzing the portion of that file activel being
//  Decoded.

import Foundation

#warning("TODO: zakkhoyt - port this file to CodableUtilities")
extension JSONDecoder {
    /// Decodes JSON directly from a file `URL` and propagates that `URL` though so it is available
    /// in `init(from decoder: any Decoder) throws`
    ///
    /// To decode directly from a URL, call `func decode(:jsonSourceURL) -> T` which will:
    /// * Load `Data` from the file and pass it along for `decode(:from:)`
    /// * Provides `CodingUserInfoKey.jsonSourceURLKey` which can be used to read
    /// the `URL` back out at any time.
    /// * Stores  `jsonSourceURL` inside `JSONDecoder.userInfo` which can then be accessd
    /// in via `Decoder.userInfo` in `init(from decoder: any Decoder) throws`
    /// * Calling `decoder.inspectJsonSourceFile(container: container)` from any place in
    /// `init(from decoder: any Decoder) throws` will provide you with a shell command to
    /// print the particular portion of the json file that is being decoded.
    public func decode<T: Decodable>(
        _ type: T.Type,
        jsonSourceURL: URL
    ) throws -> T {
        self.jsonSourceURL = jsonSourceURL
        let data = try Data(contentsOf: jsonSourceURL)
        return try decode(T.self, from: data)
    }
}

extension CodingUserInfoKey {
    /// A dictionary key intended to be used with`[CodingUserInfoKey: Any]` which can be found in:
    /// * `JSONEncoder().userInfo`
    /// * `Decoder.userInfo`
    public static let jsonSourceURLKey: CodingUserInfoKey? = {
        //    fileprivate static let jsonSourceURLKey: CodingUserInfoKey? = {
        let rawValue = "jsonSourceURL"
        guard let key = CodingUserInfoKey(rawValue: rawValue) else {
            logger.fault("Failed to create CodingUserInfoKey from rawValue: \(rawValue)")
            return nil
        }
        return key
    }()
}

extension JSONDecoder {
    /// A property getter/setter that stores a `URL` under `userInfo[CodingUserInfoKey.jsonSourceURLKey]`
    public var jsonSourceURL: URL? {
        get {
            guard let jsonSourceURLKey = CodingUserInfoKey.jsonSourceURLKey else {
                logger.fault("CodingUserInfoKey.jsonSourceURLKey is nil")
                return nil
            }
            guard let url = userInfo[jsonSourceURLKey] as? URL else {
                logger.fault("Value stored under CodingUserInfoKey.jsonSourceURLKey is not a URL")
                return nil
            }
            return url
        }
        set {
            guard let jsonSourceURLKey = CodingUserInfoKey.jsonSourceURLKey else {
                logger.fault("CodingUserInfoKey.jsonSourceURLKey is nil")
                return
            }
            userInfo[jsonSourceURLKey] = newValue
        }
    }
}

extension Decoder {
    /// A property getter that stores a `URL` under `userInfo[CodingUserInfoKey.jsonSourceURLKey]`
    public var jsonSourceURL: URL? {
        guard let jsonSourceURLKey = CodingUserInfoKey.jsonSourceURLKey else {
            logger.fault("CodingUserInfoKey.jsonSourceURLKey is nil")
            return nil
        }
        guard let url = userInfo[jsonSourceURLKey] as? URL else {
            logger.fault("Value stored under CodingUserInfoKey.jsonSourceURLKey is not a URL")
            return nil
        }
        return url
    }
}


extension Decoder {
    /// Call this function to obtain a shell command that will print the portion of the file that the Decoder is handling.
    ///
    /// Returns a shell script command to look at the portion of the JSON file
    /// ```sh
    /// # To view json value from the source file, run this command in a shell:
    /// cat /Users/zakkhoyt/code/repositories/hatch/hatch_sleep/0/HatchAssets/.gitignored/SwiftPackageGrapher/Package.json | jq '.dependencies[1].sourceControl[0].requirement'
    /// ```
    public func inspectJsonSourceFileShellCommand<Key : CodingKey> (
        container: KeyedDecodingContainer<Key>
    ) ->  String {
        "cat \(jsonSourceURL?.path() ?? "") | jq '.\(container.codingPath.absoluteCodingPath)'"
    }

//    /// Call this function to obtain a shell command that will print the portion of the file that the Decoder is handling.
//    ///
//    /// Returns a shell script command to look at the portion of the JSON file
//    /// ```sh
//    /// # To view json value from the source file, run this command in a shell:
//    /// cat /Users/zakkhoyt/code/repositories/hatch/hatch_sleep/0/HatchAssets/.gitignored/SwiftPackageGrapher/Package.json | jq '.dependencies[1].sourceControl[0].requirement'
//    /// ```
//    public func inspectJsonSourceFile<Key : CodingKey> (
//        container: KeyedDecodingContainer<Key>
//    ) ->  String {
//        let shellCommand = "cat \(jsonSourceURL?.path() ?? "") | jq '.\(container.codingPath.absoluteCodingPath)'"
//        return """
//        # To view json value from the source file, run this command in a shell:
//        \(shellCommand)
//        """
//    }
}
