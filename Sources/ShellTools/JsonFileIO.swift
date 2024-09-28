//
//  JsonFileIO.swift
//
//  Created by Zakk Hoyt on 8/5/21.
//

import Foundation

public class JsonFileIO {
    // MARK: Public vars
    
    public let jsonFileUrl: URL
    
    // MARK: Public vars
    
    private let fileName = "versions"
    private let fileExtension = "json"
    
    // MARK: Public inits
    
    public init(jsonFileUrl: URL? = nil) {
        if let jsonFileUrl {
            self.jsonFileUrl = jsonFileUrl
        } else {
            self.jsonFileUrl = URL(fileURLWithPath: FileManager.default.currentDirectoryPath, isDirectory: true)
                .appendingPathComponent(fileName)
                .appendingPathExtension(fileExtension)
        }
        
        ensureDirectoryExists(url: self.jsonFileUrl.deletingLastPathComponent())
    }
    
    // MARK: Public functions
    
    public func readDictionaryFromFile<K: Decodable, V: Decodable>() throws -> [K: V] {
        let data = try Data(contentsOf: jsonFileUrl)
        let versionBuildList = try JSONDecoder().decode([K: V].self, from: data)
#if DEBUG
        print("read from file: \(jsonFileUrl.absoluteURL)")
#endif
        return versionBuildList
    }
    
    public func writeDictionaryToFile(versionBuildList: [some Encodable: some Encodable]) throws {
        let data = try JSONEncoder().encode(versionBuildList)
        try data.write(to: jsonFileUrl)
#if DEBUG
        print("wrote to file: \(jsonFileUrl.absoluteURL)")
#endif
    }
    
    // MARK: Private functions
    
    private func ensureDirectoryExists(url: URL) {
        if FileManager.default.fileExists(atPath: url.path) == false {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: [:])
            } catch {
#if DEBUG
                print("Failed to create directory at url: \(url.absoluteURL) with error: \(error.localizedDescription)")
#endif
            }
        }
    }
}
