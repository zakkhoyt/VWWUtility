import Foundation

/// Extracts terms from a filename string using the established term syntax.
///
/// ## Term syntax
/// A *common term* is a token of the form `_[a-zA-Z0-9\-]+_`.  Adjacent terms share their
/// delimiter, so `_a_b_c_` contains three terms: `a`, `b`, `c`.  A term cluster may appear
/// anywhere in the basename — other text can precede and follow it.
///
/// ## Special case: favorite rating
/// A basename that starts with 1–10 consecutive `_` characters (followed by a non-`_`) encodes a
/// *favorite rating*.  This is detected and returned separately because its syntax differs from
/// common terms.  Phase 3 migration will convert these to the `_f{NN}_` common-term form.
public enum TermExtractor {

    // MARK: - Public API

    /// Extracts common terms from a raw filename string (basename, may include extension).
    ///
    /// - Parameter extractablePath: The basename of a file (with extension) or the leaf
    ///   component of a directory path.
    /// - Returns: Terms in left-to-right order, without surrounding `_` delimiters.
    public static func extractTerms(from extractablePath: String) -> [Term] {
        // Dotfiles (macOS sidecar files like .DS_Store, hidden configs) are never term sources.
        guard !extractablePath.hasPrefix(".") else { return [] }

        // Leading-underscore favorite rating: 2–10 leading `_` encode a V1 favorite.
        // Single `_` is just the term delimiter — not a rating.
        var syntheticFavorite: Term? = nil
        if let rating = extractFavoriteRating(from: extractablePath), rating >= 2 {
            syntheticFavorite = try? Term(basenameRepresentation: "f-\(String(format: "%02d", rating))")
        }

        // For files: strip extension so `_term_.mp4` is handled correctly.
        let stem = stripExtension(extractablePath)
        let tokens = commonTerms(in: stem)
        let extracted = tokens.enumerated().compactMap { (index, token) -> Term? in
            // First token only: pure 1–4 digit string → auto-promote to ord-<digits>
            if index == 0,
               token.range(of: #"^[0-9]{1,4}$"#, options: .regularExpression) != nil {
                return try? Term(basenameRepresentation: "ord-\(token)")
            }
            // Any token: f followed by 1–4 digits with no dash → promote to f-<digits>
            if token.range(of: #"^f[0-9]{1,4}$"#, options: .regularExpression) != nil {
                let digits = String(token.dropFirst())
                return try? Term(basenameRepresentation: "f-\(digits)")
            }
            return try? Term(basenameRepresentation: token)
        }

        if let syntheticFavorite {
            return [syntheticFavorite] + extracted
        }
        return extracted
    }

    /// Returns the *favorite rating* (number of leading underscores, 1–10) if the basename
    /// starts with that pattern, otherwise `nil`.
    ///
    /// The favorite rating is encoded as 1–10 consecutive `_` at the very start of the
    /// extractable path, followed immediately by a non-`_` character.
    /// Example: `__best_shot.jpg` → rating `2`.
    public static func extractFavoriteRating(from extractablePath: String) -> Int? {
        let stem = stripExtension(extractablePath)
        // Match 1-10 leading underscores followed by a non-underscore (or end of string).
        let pattern = /^([_]{1,10})(?=[^_]|$)/
        guard let match = try? pattern.firstMatch(in: stem) else { return nil }
        return match.output.1.count
    }

    // MARK: - Private helpers

    /// Removes the file extension from a basename.
    /// `"video_shoe_.mp4"` → `"video_shoe_"`.
    /// Directories (no dot) are returned unchanged.
    private static func stripExtension(_ name: String) -> String {
        // Use URL to strip extension — handles multi-dot names like `archive.tar.gz`.
        let url = URL(fileURLWithPath: name)
        let ext = url.pathExtension
        guard !ext.isEmpty else { return name }
        return String(name.dropLast(ext.count + 1)) // drop "." + extension
    }

    /// Finds all non-overlapping `_token_` matches in `stem` and returns the inner tokens.
    ///
    /// Because adjacent terms share their delimiter (e.g. `_a_b_`) we scan with a sliding
    /// window: after each match we continue from the position of the trailing `_` so it can
    /// serve as the leading `_` for the next term.
    ///
    /// A trailing token with no closing `_` (e.g. `_dunk_clip`) is also captured if it
    /// consists entirely of valid term characters (`[a-zA-Z0-9\-]`).
    private static func commonTerms(in stem: String) -> [String] {
        var terms: [String] = []

        // Leading token: text before the first `_` that consists entirely of valid term chars.
        // Captures e.g. "Xcode" from "Xcode_20240513143322-muted.mp4".
        if let firstUnderscore = stem.firstIndex(of: "_") {
            let leading = String(stem[stem.startIndex ..< firstUnderscore])
            if !leading.isEmpty,
               leading.range(of: #"^[a-zA-Z0-9\-]+$"#, options: .regularExpression) != nil {
                terms.append(leading)
            }
        }

        var searchStart = stem.startIndex

        while searchStart < stem.endIndex {
            // Find next `_`
            guard let underscoreStart = stem[searchStart...].firstIndex(of: "_") else { break }

            let afterUnderscore = stem.index(after: underscoreStart)
            guard afterUnderscore < stem.endIndex else { break }

            if let underscoreEnd = stem[afterUnderscore...].firstIndex(of: "_") {
                // Standard case: token sits between two `_` delimiters.
                let token = String(stem[afterUnderscore ..< underscoreEnd])
                if !token.isEmpty, token.range(of: #"^[a-zA-Z0-9\-]+$"#, options: .regularExpression) != nil {
                    terms.append(token)
                }
                // Reuse the closing `_` as the potential opening `_` for the next term.
                searchStart = underscoreEnd
            } else {
                // Trailing term: valid chars after the last `_` with no closing delimiter.
                let token = String(stem[afterUnderscore...])
                if !token.isEmpty, token.range(of: #"^[a-zA-Z0-9\-]+$"#, options: .regularExpression) != nil {
                    terms.append(token)
                }
                break
            }
        }

        return terms
    }
}
