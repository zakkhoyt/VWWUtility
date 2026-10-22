import Foundation

/// Public entry point for term operations on file URLs.
public struct TermManager {

    /// Extracts all terms from the basename of `fileURL`.
    public static func extractTerms(fileURL: URL) async throws -> [Term] {
        TermExtractor.extractTerms(from: fileURL.lastPathComponent)
    }

    /// Renames `fileURL` by injecting `terms` at `location` in the basename.
    ///
    /// Returns the URL of the renamed file.
    public static func rename(
        fileURL: URL,
        terms: [Term],
        location: Term.BasenameLocation
    ) async throws -> URL {
        // TODO: implement rename logic
        fatalError("TermManager.rename not yet implemented")
    }
}
