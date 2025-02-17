//
//  CodingKey+Helpers.swift
//
//  Created by Zakk Hoyt on 2025-01-06.
//

import Foundation
import RegexBuilder

extension [CodingKey] {
    /// Represents an array of `[CodingKey]` as a dot delimited `String`.
    /// I.E. "current.state.desired.current"
    public var absoluteCodingPath: String {
        
        return map { $0.stringValue }
            .map {
                // Converts "Index X" into "[X]"
                // "dependencies.Index 1.sourceControl.Index 0.requirement"
                let matches = $0.matches(of: #/(.*Index )([0-9]+)/#)
                if let match = matches.first {
                    return "[\(match.2)]"
                } else {
                    return $0
                }
            }
            .joined(separator: ".")
            // With the Index X replacements above
            // "dependencies.[1].sourceControl.[0].requirement"
            // but we want
            // "dependencies[1].sourceControl[0].requirement"
            .replacingOccurrences(of: ".[", with: "[")

        
#warning("TODO: zakkhoyt - Replace all these steps above with Regex Capture group matches")
        //        let matches = out.matches(of: #/(Index )([0-9]+)/#)
        //        matches.forEach { // Regex<Regex<(Substring, Substring, Substring)>.RegexOutput>.Match in
        //            // Mutate matches?
        //        }
        //        // Join matches?

    }
}
  
