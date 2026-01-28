//
//  Array+BinarySearch.swift
//  VWWUtility
//
//  Created by Zakk Hoyt on 7/7/25.
//

extension Array where Element: Comparable {
    /// Returns the index computed by a recursive binary search
    /// - Precondition: `self` must be `sorted`. `Element` must be `Comparable`
    public func binarySearch(key: Element, range: Range<Int>) -> Index? {
        if range.lowerBound >= range.upperBound {
            return range.upperBound
        } else {
            let midIndex = range.lowerBound + (range.upperBound - range.lowerBound) / 2
            if self[midIndex] > key {
                return binarySearch(key: key, range: range.lowerBound..<midIndex)
            } else if self[midIndex] < key {
                return binarySearch(key: key, range: midIndex + 1..<range.upperBound)
            } else {
                return midIndex
            }
        }
    }
}
