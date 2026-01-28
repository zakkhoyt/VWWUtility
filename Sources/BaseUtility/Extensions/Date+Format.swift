//
// Date+Format.swift
//
//
// Created by Zakk Hoyt on 12/5/23.
//

import Foundation

public protocol DateFormatProvider {
    var format: String { get }
}

public enum DateFormat: DateFormatProvider {
    case logFile
    case hourMinuteSecond
    case accurate
    case http
    case httpLocalAccurate
    case custom(format: String)

    public var format: String {
        switch self {
        case .logFile: "yyyyMMddHHmmss"
        case .hourMinuteSecond: "HH:mm:ss"
        case .accurate: "hh:mm:ss.SSS"
        case .http: "yyyy-MM-dd HH:mm:ss"
        case .httpLocalAccurate: "yyyy-MM-dd HH:mm:ss.SSS"
        case .custom(let format): format
        }
    }
}

public class DateFormatCache {
    // MARK: Public variables

    public static let shared = DateFormatCache()

    // MARK: Private variables

    private var mainCache = NSCache<NSString, DateFormatter>()
    private var backgroundCache = NSCache<NSString, DateFormatter>()

    // MARK: Inits

    public init() {}

    // MARK: Public methods

    public func formatter(
        dateFormat: String
    ) -> DateFormatter {
        let cache = Thread.isMainThread ? mainCache : backgroundCache

        if let formatter = cache.object(forKey: dateFormat as NSString) {
            return formatter
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = dateFormat
            // Setting the local to US will remove the dreaded dangling am/pm
            // https://stackoverflow.com/questions/53638277/dateformatter-sets-am-pm-by-default
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = NSTimeZone.local
            cache.setObject(formatter, forKey: dateFormat as NSString)
            return formatter
        }
    }

    public func formatterFrom(
        formatProvider: any DateFormatProvider
    ) -> DateFormatter {
        formatter(dateFormat: formatProvider.format)
    }
}

extension String {
    /// Converts a `String` to a `Date` using `format`.
    /// - Important: This function will `preconditionFailure` if a `Date` cannot be extracted.
    /// - Requires: A valid/matching pair of `String` and `DateFormatting`.
    /// - Parameter formatProvider: A concrete`DateFormatProvider` (see `DateFormat`).
    /// - Returns: A `Date` instance
    public func date(
        formatProvider: any DateFormatProvider
    ) -> Date {
        let formatter = DateFormatCache.shared.formatterFrom(formatProvider: formatProvider)
        guard let date = formatter.date(from: self) else {
            let formatString = formatter.dateFormat ?? "<nil>"
            preconditionFailure("Failed to create date from string (\(self)) using format (\(formatString))")
        }
        return date
    }
}

extension Date {
    public func string(
        formatProvider: any DateFormatProvider
    ) -> String {
        let formatter: DateFormatter = DateFormatCache.shared.formatterFrom(formatProvider: formatProvider)
        return formatter.string(from: self)
    }
}

extension Date {
    public var iso8601String: String {
        ISO8601DateFormatter.string(
            from: self,
            timeZone: .current,
            formatOptions: [.withFullDate, .withFullTime]
        )
    }
}
