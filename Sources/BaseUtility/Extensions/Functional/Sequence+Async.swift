//
//  Sequence+Async.swift
//  HatchModules
//
//  Created by Zakk Hoyt on 2/6/25.
//

// MARK: forEach

extension Sequence {
    /// A version of `.forEach { _ in }` which supports `async throws`
    ///
    /// ## References
    ///
    /// * [swiftbysundell](https://www.swiftbysundell.com/articles/async-and-concurrent-forEach-and-map/)
    public func forEachAsync(
        _ operation: (Element) async throws -> Void
    ) async rethrows {
        for element in self {
            try await operation(element)
        }
    }

    /// A version of `.forEach { _ in }` which supports `async throws` and
    /// runs the loops in cascade
    ///
    /// ## References
    ///
    /// * [swiftbysundell](https://www.swiftbysundell.com/articles/async-and-concurrent-forEach-and-map/)
    public func forEachAsyncConcurrent(
        _ operation: @escaping @Sendable (Element) async -> Void
    ) async {
        // A task group automatically waits for all of its

        // sub-tasks to complete, while also performing those
        // tasks in parallel:
        await withTaskGroup(of: Void.self) { group in
            for element in self {
                group.addTask {
                    await operation(element)
                }
            }
        }
    }
}

// MARK: map

extension Sequence {
    /// A version of `.map { _ in }` which supports `async throws`
    ///
    /// ## References
    ///
    /// * [swiftbysundell](https://www.swiftbysundell.com/articles/async-and-concurrent-forEach-and-map/)
    public func mapAsync<T>(
        _ transform: (Element) async throws -> T
    ) async rethrows -> [T] {
        var values = [T]()

        for element in self {
            try await values.append(transform(element))
        }

        return values
    }
}

extension Sequence {
    /// A version of `.map { _ in }` which supports `async throws`
    ///
    /// A version of `.forEach { _ in }` which supports `async throws` and
    /// runs the loops in cascade
    ///
    /// ## References
    ///
    /// * [swiftbysundell](https://www.swiftbysundell.com/articles/async-and-concurrent-forEach-and-map/)
    public func mapConcurrentAsync<T: Sendable>(
        _ transform: @escaping (Element) async throws -> T
    ) async throws -> [T] {
        let tasks = map { element in
            Task {
                try await transform(element)
            }
        }

        return try await tasks.mapAsync { task in
            try await task.value
        }
    }

    /// Creates a map extension that uses `AsyncSequence` while preserving order.
    public func mapConcurrentAsync<T: Sendable>(
        _ transform: @escaping @Sendable (Element) async -> T
    ) async -> [T] {
        await withTaskGroup(of: (Int, T).self) { group in
            for (index, element) in self.enumerated() {
                group.addTask { await (index, transform(element)) }
            }
            var results: [(Int, T)] = []
            for await result in group {
                results.append(result)
            }
            return results.sorted { $0.0 < $1.0 }.map { $0.1 }
        }
    }
}

// MARK: compactMap

extension Sequence {
    /// A version of `.map { _ in }` which supports `async throws`
    ///
    /// ## References
    ///
    /// * [swiftbysundell](https://www.swiftbysundell.com/articles/async-and-concurrent-forEach-and-map/)
    public func compactMapAsync<T: Sendable>(
        _ transform: (Element) async throws -> T?
    ) async rethrows -> [T] {
        var values = [T]()
        for element in self {
            guard let transformedElement = try await transform(element) else {
                continue
            }
            values.append(transformedElement)
        }
        return values
    }
}

extension Sequence {
    /// A version of `.compactMap { _ in }` which supports `async throws` and
    /// runs the loops in cascade
    ///
    /// ## References
    ///
    /// * [swiftbysundell](https://www.swiftbysundell.com/articles/async-and-concurrent-forEach-and-map/)
    public func compactMapConcurrent<T: Sendable>(
        _ transform: @escaping @Sendable (Element) async throws -> T
    ) async throws -> [T] {
        let tasks = compactMap { element in
            Task {
                try await transform(element)
            }
        }

        return try await tasks.compactMapAsync { task in
            try await task.value
        }
    }
}

// MARK: reduce

extension Sequence {
    /// A version of `.map { _ in }` which supports `async throws`
    ///
    /// ## References
    ///
    /// * [swiftbysundell](https://www.swiftbysundell.com/articles/async-and-concurrent-forEach-and-map/)
    public func reduceAsync<Result>(
        _ initialResult: Result,
        _ nextPartialResult: (inout Result, Element) async throws -> Void
    ) async rethrows -> Result {
        var result = initialResult
        for element in self {
            try await nextPartialResult(&result, element)
        }
        return result
    }
    //    func reduceAsync<T>(
    //        _ transform: (Element) async throws -> T?
    //    ) async rethrows -> [T] {
    //        var values = [T]()
    //        for element in self {
    //            if let transformedElement = try await transform(element) {
    //                values.append(transformedElement)
    //            } else {
    //                // nothing to add
    //            }
    //        }
    //        return values
    //    }
}
