import Foundation
import XCTest

/// Creates and tears down a temporary directory tree for filesystem-based tests.
public final class MockFileTree {

    public let rootURL: URL

    public init() throws {
        let tmp = FileManager.default.temporaryDirectory
        rootURL = tmp.appendingPathComponent("ZBTermsKitTests_\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(at: rootURL, withIntermediateDirectories: true)
    }

    deinit {
        try? FileManager.default.removeItem(at: rootURL)
    }

    /// Creates a file at `relativePath` (creating intermediate directories as needed).
    @discardableResult
    public func addFile(_ relativePath: String, content: String = "") throws -> URL {
        let url = rootURL.appendingPathComponent(relativePath)
        try FileManager.default.createDirectory(
            at: url.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        try content.write(to: url, atomically: true, encoding: .utf8)
        return url
    }

    /// Creates a directory at `relativePath`.
    @discardableResult
    public func addDirectory(_ relativePath: String) throws -> URL {
        let url = rootURL.appendingPathComponent(relativePath, isDirectory: true)
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        return url
    }

    /// Resolves `relativePath` within the tree to an absolute URL.
    public func url(for relativePath: String) -> URL {
        rootURL.appendingPathComponent(relativePath)
    }
}

// MARK: - Standard fixtures

extension MockFileTree {

    /// Creates a representative file tree that exercises term extraction, exclusion, and nesting.
    public static func standard() throws -> MockFileTree {
        let tree = try MockFileTree()

        // Files with common terms (simple topic-only terms, no hyphens in term names)
        try tree.addFile("videos/march madness_shoe_at14m3s_swish_f09_ on youtube.com - user - title.mp4")
        try tree.addFile("videos/practice_shoe_dunk_at30s_for5s_clip.mp4")
        try tree.addFile("videos/game_highlights_shoered_at2m15s.mp4")

        // File with favorite rating (leading underscores)
        try tree.addFile("photos/__best_shot_shoe.jpg")

        // File with zero terms
        try tree.addFile("photos/untitled.jpg")

        // Regular file with terms
        try tree.addFile("docs/notes_shoe_practice.txt")

        // File for --exclude testing (basename contains [clip])
        try tree.addFile("clips/game_at30s_for10s[clip].mp4")

        // Nested depth-2 file (for max-depth tests)
        try tree.addFile("deep/nested/file_shoe_deep.mp4")

        return tree
    }
}
