//
//  CURLLog.swift
//  HatchBrain
//
//  Created by Zakk Hoyt on 11/11/16.
//  Copyright © 2016 Zakk Hoyt. All rights reserved.
//

import Foundation

#if os(Linux)
import FoundationNetworking
#endif

// TODO: Logger support?

private enum CurlArgs {
    static let command = "curl"
    static let verbosity = "--verbose"
    static let header = #"-H "%@:%@""#
    static let request = "-X %@ \"%@\""
    static let compactData = "-d '%@'"
    static let prettyData = "-d '\n%@\n'"
}

enum CurlStyle {
    case compact
    case pretty
    
    var separator: String {
        switch self {
        case .compact: " "
        case .pretty: "\n"
        }
    }
    
    var bashSeparator: String {
        switch self {
        case .compact: " "
        case .pretty: " \\\n"
        }
    }
    
    var writingOptions: JSONSerialization.WritingOptions {
        switch self {
        case .compact: []
        case .pretty: [.prettyPrinted, .sortedKeys]
        }
    }
}

enum CURLLog {
    enum NoCurlError: Swift.Error {
        case noRequest // print("No request in URLSession task. Offline?")
        case noResponse // print("No response in URLSession task. Offline? Cancelled?")
        case noHttpResponse // print("No httpResponse in URLSession task. Offline?")
    }
    
    static let redactedString = "[redacted]"
    
    static func log(
        style: CurlStyle = .compact,
        task: URLSessionTask,
        data: Data?,
        error: Error? = nil,
        metrics: URLSessionTaskMetrics? = nil
    ) throws -> String {
        guard let request = task.originalRequest else {
            throw NoCurlError.noRequest
        }
        
//        guard let response = task.response else {
//            throw NoCurlError.noResponse
//        }
//
//        guard let httpResponse = response as? HTTPURLResponse else {
//            throw NoCurlError.noHttpResponse
//        }
        
        let response = task.response
        
//        let httpResponse = task.response as? HTTPURLResponse

        return try composeCURL(
            style: style,
            request: request,
            response: response,
            data: data,
            metrics: metrics,
            verbose: true
        )
    }
    
    private static func composeCURL(
        style: CurlStyle,
        request: URLRequest,
        response: URLResponse?,
        data: Data?,
        metrics: URLSessionTaskMetrics? = nil,
        verbose: Bool = false
    ) throws -> String {
        let titleString: String = {
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                return ""
            }
            if 200..<300 ~= statusCode {
                return "\n**************** HTTP SUCCESS \(statusCode) **********************"
            } else {
                return "\n**************** HTTP ERROR \(statusCode) **********************"
            }
        }()
        
        let requestString = try """
        **** REQUEST ****
        \(request.curl(style: style, verbose: verbose))
        """
        
        let metricsString = """
        **** METRICS ****
        \(metrics?.curl ?? "n/a")
        """
        
        let responseHeaders: String = {
            guard let httpUrlResponse = response as? HTTPURLResponse else {
                return ""
            }
            
            return httpUrlResponse.allHeaderFields
                .compactMap { key, value in
                    guard let sKey = key as? String, let sValue = value as? String else { return nil }
                    if !verbose {
                        guard sKey == "x-hatch-request-id" else { return nil }
                    }
                    return String(format: CurlArgs.header, sKey, sValue)
                }
                .joined(separator: style.bashSeparator)
        }()
        
        let responseHeadersString = """
        **** RESPONSE HEADERS ****
        \(responseHeaders)
        """
        
        let responseString = """
        **** RESPONSE ****
        \(payloadStringFrom(data: data, style: style))
        """
        
        let suffixString = "****************************************************"
        
        // Append metrics if this operation took longer than x seconds
        let metricsDuration: TimeInterval = 0.5
        
        if verbose {
            let requestHeadersString = """
            **** REQUEST HEADERS ****
            \(request.description)
            """
            
            let metricsAndResponseString: String = {
                guard let metrics, metrics.taskInterval.duration >= metricsDuration else {
                    return responseHeadersString
                }
                return """
                \(metricsString)
                \(responseHeadersString)
                """
            }()
            
            let output = """
            \(titleString)
            \(requestString)
            \(requestHeadersString)
            \(metricsAndResponseString)
            \(responseString)
            \(suffixString)
            """
            return output
        } else {
            let metricsAndPayloadString: String = {
                guard let metrics, metrics.taskInterval.duration >= metricsDuration else {
                    return responseString
                }
                return """
                \(metricsString)
                \(responseString)
                """
            }()
            
            let output = """
            \(titleString)
            \(requestString)
            \(responseHeadersString)
            \(metricsAndPayloadString)
            \(suffixString)
            """
            return output
        }
    }
    
    private static func payloadStringFrom(
        data: Data?,
        style: CurlStyle
    ) -> String {
        guard let data else { return "" }
        
        func formattedString(from json: Any) -> String {
            do {
                let data = try JSONSerialization.data(withJSONObject: json, options: style.writingOptions)
                return String(data: data, encoding: .utf8) ?? "Failed to represent payload"
            } catch {
                return "Failed to represent payload"
            }
        }
        
        do {
            if let dictionary = try JSONSerialization.jsonObject(
                with: data,
                options: .mutableContainers
            ) as? NSMutableDictionary {
                // replace sensitive information
                //                if !isQA() {
                //                    dictionary.redactResponsePayloadValues()
                //                }
                return formattedString(from: dictionary)
            }
        } catch {
            if let string = String(data: data, encoding: .utf8) {
                return string
            } else {
                return "Could not print payload"
            }
        }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSArray {
                return formattedString(from: json)
            }
        } catch {
            if let string = String(data: data, encoding: .utf8) {
                return string
            } else {
                return "Could not print payload"
            }
        }
        
        if let str = String(data: data, encoding: .utf8) {
            return str
        }
        
        // TODO: Print Int, Bool, String, other primitives
        
        // Assume we are expecting raw data
        return "Data of \(data.count) bytes"
    }
}

extension URLRequest {
    // TODO: Set up redacting tool
    func curl(
        style: CurlStyle,
        verbose: Bool = false
    ) throws -> String {
        let verboseString = verbose ? CurlArgs.verbosity : nil
        
        // let headerString: String? = (isQA() ? allHTTPHeaderFields : allHTTPHeaderFields?.redactHeaderValues())?
        let headerString: String? = allHTTPHeaderFields?
            .compactMap { key, value in
                if key == "Accept-Language" {
                    nil
                } else {
                    String(format: CurlArgs.header, key, value)
                }
            }
            .joined(separator: style.bashSeparator)
        
        let dataString: String? = try {
            guard let httpBody = self.httpBody else { return nil }
            guard let dictionary = try JSONSerialization.jsonObject(
                with: httpBody,
                options: JSONSerialization.ReadingOptions.mutableContainers
            ) as? NSMutableDictionary else { return nil }
            
            // We want to strip out any of our redacted keywords in public facing builds.
            //                if !isQA() {
            //                    dictionary.redactRequestPayloadValues()
            //                }
            
            // Convert dictionary to data (formatted as compact or pretty)
            let safeData = try JSONSerialization.data(withJSONObject: dictionary, options: style.writingOptions)
            
            // Convert formatted data to String
            guard let jsonString = String(data: safeData, encoding: .utf8) else { return nil }
            let format: String = switch style {
            case .compact: CurlArgs.compactData
            case .pretty: CurlArgs.prettyData
            }
            return String(format: format, jsonString)
        }()
        
        let requestString: String = {
            guard let httpMethod = self.httpMethod, let urlString = self.url?.absoluteString else { return "" }
            return String(format: CurlArgs.request, httpMethod, urlString)
        }()
        
        return [
            CurlArgs.command,
            verboseString,
            headerString,
            dataString,
            requestString
        ]
            .compactMap { $0 }
            .joined(separator: style.bashSeparator)
    }
}

extension [String: String] {
    private func redactHeaderValues() -> [Key: Value] {
        reduce([:]) { result, tuple in
            let (key, value) = tuple
            let safeValue = ["X-HatchBaby-Auth"].contains(key) ? CURLLog.redactedString : value
            let d2: [String: String] = [key: safeValue]
            return result.merging(d2) { $1 }
        }
    }
}

extension NSMutableDictionary {
    /// Strips out any `values` which contain sensitive information (judging by the `key`)
    private func redactRequestPayloadValues() {
        ["password"]
            .compactMap { self[$0] == nil ? nil : $0 } // Keys which have a value
            .forEach { self[$0] = CURLLog.redactedString } // Replace values
    }
}

extension NSMutableDictionary {
    /// Strips out any `values` which contain sensitive information (judging by the `key`)
    private func redactResponsePayloadValues() {
        // po allKeys
        // - 0 : status
        // - 1 : message
        // - 2 : payload
        // - 3 : sync
        //        guard let payloadDictionary = self["payload"] as? NSMutableDictionary else { return }
        
        // TODO: A more abstracted way to redact
        // A list of keys for which we want to redact the value
        //        let keysToRedact = IoTCertificate.CodingKeys.allCases.map { $0.rawValue }
        //
        //        payloadDictionary.allKeys
        //            .compactMap { $0 as? String } // keys as String
        //            .filter { keysToRedact.contains($0) } // only keys in the list to redact
        //            .forEach { payloadDictionary[$0] = CURLLog.redactedString } // replace the value
    }
}

extension URLSessionTaskMetrics {
    var curl: String? {
        guard let first = transactionMetrics.first else { return nil }
        guard let dictionary = first.curlDictionary.mutableCopy() as? NSMutableDictionary else { return nil }
        if let taskIntervalString {
            dictionary["taskInterval"] = taskIntervalString
        }
        return dictionary.description
    }
    
    private var taskIntervalString: String? {
        String(format: "%.03f s", taskInterval.duration)
    }
}

extension URLSessionTaskTransactionMetrics {
    var curlDictionary: NSDictionary {
        // Use NSDictionary here for it's description formatting
        let dictionary = NSMutableDictionary()
        //        if let elapsedString = self.elapsedString {
        //            dictionary["elapsed"] = elapsedString
        //        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        if let fetchStartDate {
            dictionary["fetchStartDate"] = dateFormatter.string(from: fetchStartDate) //  fetchStartDate.string(format: .httpLocalAccurate)
        }
        if let responseEndDate {
            dictionary["responseEndDate"] = dateFormatter.string(from: responseEndDate) // responseEndDate.string(format: .httpLocalAccurate)
        }
        dictionary["isCellular"] = "\(isCellular)"
        dictionary["isExpensive"] = "\(isExpensive)"
        dictionary["isConstrained"] = "\(isConstrained)"
        
        return dictionary
    }
    
    var curl: String {
        curlDictionary.description
    }
    
    private var elapsed: TimeInterval? {
        guard let fetchStartDate,
              let responseEndDate else {
            return nil
        }
        return responseEndDate.timeIntervalSince(fetchStartDate)
    }
    
    private var elapsedString: String? {
        guard let elapsed else { return nil }
        return String(format: "%.03f s", elapsed)
    }
}
