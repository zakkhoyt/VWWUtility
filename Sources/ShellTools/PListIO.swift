//
//  PListIO.swift
//
//  Created by Zakk Hoyt on 8/5/21.
//

import Foundation

public enum PListIOError: Error {
    case failedToReadPlist(String)
    case failedToDecode
    case noValueForKey(String)
}

open class PlistIO {
    public let plistUrl: URL
    
    public init(plistUrl: URL) {
        self.plistUrl = plistUrl
    }
    
    open func readPropertyList<R>(key: String) throws -> R {
        var propertyListFormat = PropertyListSerialization.PropertyListFormat.xml // Format of the Property List.
        
        guard let plistXML = FileManager.default.contents(atPath: plistUrl.path) else {
            throw PListIOError.failedToReadPlist(plistUrl.path)
        }
        do {
            guard let plistData = try PropertyListSerialization.propertyList(
                from: plistXML,
                options: .mutableContainersAndLeaves,
                format: &propertyListFormat
            ) as? [String: AnyObject] else {
                throw PListIOError.failedToDecode
            }
            guard let r = plistData[key] as? R else {
                throw PListIOError.failedToDecode
            }
            return r
        } catch {
            throw error
        }
    }
}
