//
//  APIService.swift
//
//  Created by Zakk Hoyt on 6/30/22.
//

import Foundation

#if os(Linux)
import FoundationNetworking
#endif

class APIMetrics {
    private var taskMetrics: [Int: URLSessionTaskMetrics] = [:]
    private let metricsQueue = DispatchQueue(label: "API Metrics Queue", attributes: .concurrent)
    
    func insert(taskIdentifier: Int, metrics: URLSessionTaskMetrics) {
        metricsQueue.async(flags: .barrier) { [weak self] in
            self?.taskMetrics[taskIdentifier] = metrics
        }
    }
    
    func remove(taskIdentifier: Int, completion: @escaping (URLSessionTaskMetrics?) -> Void) {
        metricsQueue.async(flags: .barrier) { [weak self] in
            let metrics = self?.taskMetrics.removeValue(forKey: taskIdentifier)
            completion(metrics)
        }
    }
}

open class APIService: NSObject {
    public enum Error: Swift.Error {
        case httpBodyFailed
        case noDataOrResponse
    }
    
    private lazy var session = URLSession(
        configuration: .default,
        delegate: self,
        delegateQueue: OperationQueue()
    )

    private let apiMetrics = APIMetrics()
    
    override public init() {}
    
    /// This sends URL requests the old fashioned way (closures). Why?
    /// Because the async/await version of `session.data(...` are not shipped
    /// with Linux distro.
    /// That's okay though. We will use the old way and then wrap it ourselves
    /// with async/await continuation. This leaves us with the same interface
    /// that we would have had anyhow.
    /// - Attention: It is recommended to use the `async/await` variant of this function (provided below).
    /// - Parameters:
    ///   - url: A `URL`
    ///   - httpMethod: An instance of`URLRequest.HTTPMethod` (`.get`, `.post`, etc...)
    ///   - headers: Any HTTP headers to send with the request `[String: String]`
    ///   - parameters: Payload for `.post` and such.
    ///   - completion: Called on completion or error. `(Result<(Data, URLResponse), Swift.Error>) -> Void`
    public func send(
        url: URL,
        httpMethod: URLRequest.HTTPMethod,
        headers: [String: String] = ["Content-type": "application/json"],
        requestValues: [String: String] = [:],
        parameters: [String: Any] = [:],
        completion: @escaping (Result<(Data, URLResponse), any Swift.Error>) -> Void
    ) {
        #warning("FIXME: @zakkhoyt convert optionals to not in a single place here")
        var request: URLRequest = {
            if httpMethod == .get {
                guard let qurl = url.querify(queryParameters: parameters) else {
                    preconditionFailure("Failed to create URL from query params")
                }
                return URLRequest(url: qurl)
            } else {
                var request = URLRequest(url: url)
                do {
                    let paramsData = try JSONSerialization.data(withJSONObject: parameters, options: [])
                    request.httpBody = paramsData
                    return request
                } catch {
                    preconditionFailure("Failed to deocde json")
                }
            }
        }()
        request.httpMethod = httpMethod.rawValue
        headers.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        requestValues.forEach { (key: String, value: String) in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        var task: URLSessionTask?
        task = session.dataTask(with: request) { [weak self] data, response, error in
            if let task {
                if let error {
                    dump(error)
                }
                self?.apiMetrics.remove(taskIdentifier: task.taskIdentifier) { metrics in
                    do {
                        try print(
                            CURLLog.log(
                                style: .pretty,
                                task: task,
                                data: data,
                                error: error,
                                metrics: metrics
                            )
                        )
                    } catch {
                        print("ERROR in curl log: \(error.localizedDescription)")
                    }
                }
            }

            if let error {
                completion(.failure(error))
                return
            }
            guard let data, let response else {
                completion(.failure(Error.noDataOrResponse))
                return
            }
            completion(.success((data, response)))
        }
        task?.resume()
    }
    
    /// This sends URL requests the new `async/await` way.
    /// - Parameters:
    ///   - url: A `URL`
    ///   - httpMethod: An instance of`URLRequest.HTTPMethod` (`.get`, `.post`, etc...)
    ///   - headers: Any HTTP headers to send with the request `[String: String]`
    ///   - parameters: Payload for `.post` and such.
    /// - Returns: `(Data, URLResponse)`
    /// - Throws: `Swift.Error`
    public func send(
        url: URL,
        httpMethod: URLRequest.HTTPMethod,
        headers: [String: String] = ["Content-type": "application/json"],
        requestValues: [String: String] = [:],
        parameters: [String: Any] = [:]
    ) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            send(
                url: url,
                httpMethod: httpMethod,
                headers: headers,
                requestValues: requestValues,
                parameters: parameters
            ) { result in
                switch result {
                case .success(let response):
                    continuation.resume(with: .success(response))
                case .failure(let error):
                    continuation.resume(with: .failure(error))
                }
            }
        }
    }
}

extension APIService: URLSessionDataDelegate {
    // Receive metric data for your network request.
    public func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didFinishCollecting metrics: URLSessionTaskMetrics
    ) {
        apiMetrics.insert(taskIdentifier: task.taskIdentifier, metrics: metrics)
    }
}

extension APIService {
    public func dataToResult<T: Decodable>(
        from data: Data
    ) -> Result<T, any Swift.Error> {
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return .success(decoded)
        } catch {
            return .failure(error)
        }
    }
    
    public func dataToType<T: Decodable>(
        from data: Data
    ) throws -> T {
        try JSONDecoder().decode(T.self, from: data)
    }
}

extension Result {
    public func flatMap<B>(
        _ transform: (Success) -> Result<B, Failure>
    ) -> Result<B, Failure> {
        package(
            ifSuccess: transform,
            ifFailure: Result<B, Failure>.failure
        )
    }

    // MARK: Private functions

    private func package<B>(
        ifSuccess: (Success) -> B,
        ifFailure: (Failure) -> B
    ) -> B {
        switch self {
        case .success(let value):
            ifSuccess(value)
        case .failure(let value):
            ifFailure(value)
        }
    }
}

extension URLRequest {
    public enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case delete = "DELETE"
        case put = "PUT"
    }
}

extension URL {
    func querify(
        queryParameters: [String: Any]?
    ) -> URL? {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return nil
        }
        
        components.queryItems = queryParameters?
            .sorted(by: \.key)
            .map { URLQueryItem(name: $0, value: String(describing: $1)) }
        components.percentEncodedQuery = components
            .percentEncodedQuery?
            .replacingOccurrences(of: "+", with: "%2B")
        return components.url
    }
}

extension Sequence {
    func sorted(
        by keyPath: KeyPath<Element, some Comparable>
    ) -> [Element] {
        sorted { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
    }
    
    func sorted<T: Comparable>(
        with order: [T],
        by keyPath: KeyPath<Element, T>
    ) -> [Element] {
        sorted { firstItem, secondItem -> Bool in
            if let first = order.firstIndex(of: firstItem[keyPath: keyPath]),
               let second = order.firstIndex(of: secondItem[keyPath: keyPath]) {
                return first < second
            }
            return false
        }
    }
}
