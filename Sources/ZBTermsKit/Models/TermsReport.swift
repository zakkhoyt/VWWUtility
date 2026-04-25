import Foundation

/// Top-level result produced by crawling a directory hierarchy and extracting filename terms.
public struct TermsReport: Codable, Sendable, Equatable {

    // MARK: - Nested types

    /// Whether a `PathItem` points to a file or a directory.
    public enum PathContentType: String, Codable, Sendable, Equatable {
        case file
        case dir
    }

    /// A single entry in the traversed hierarchy with enough context to reconstruct both
    /// relative and absolute paths, and to identify which portion of the path holds terms.
    public struct PathItem: Codable, Sendable, Equatable {

        enum CodingKeys: String, CodingKey {
            case pathContentType = "path_content_type"
            case path
            case extractablePath = "extractable_path"
            case absolutePath = "absolute_path"
        }

        /// Whether this item is a `file` or a `dir`.
        public let pathContentType: PathContentType

        /// Path of the item relative to `rootDir`.
        public let path: String

        /// The portion of `path` from which terms are extracted.
        ///
        /// For `TermContainer.file`: the basename (e.g. `d.mp4` from `a/b/c/d.mp4`).
        /// For `TermContainer.dir`: the leaf directory component (e.g. `c` from `a/b/c`).
        public let extractablePath: String

        /// The absolute path of the item (`rootDir + "/" + path`).
        public let absolutePath: String
    }

    /// Associates a `PathItem` with the list of terms extracted from its `extractablePath`.
    public struct TermUsage: Codable, Sendable, Equatable {

        enum CodingKeys: String, CodingKey {
            case pathItem = "path_item"
            case terms
        }

        public let pathItem: PathItem

        /// Terms extracted from `pathItem.extractablePath`, in left-to-right order.
        /// Does not include the surrounding `_` delimiters.
        public let terms: [Term]
    }

    /// Serializable form of a single `Term.Parameter`, including `parameter_type` which is
    /// excluded from `Term.Parameter`'s own JSON encoding (it is a computed property there).
    public struct ParameterOutput: Codable, Sendable, Equatable {

        enum CodingKeys: String, CodingKey {
            case basenameRepresentation = "basename_representation"
            case parameterType          = "parameter_type"
        }

        public let basenameRepresentation: String
        /// `"flag"` for presence-only parameters; `"option"` for key=value parameters.
        public let parameterType: String

        init(from parameter: Term.Parameter) {
            self.basenameRepresentation = parameter.basenameRepresentation
            switch parameter.parameterType {
            case .flag:   self.parameterType = "flag"
            case .option: self.parameterType = "option"
            }
        }
    }

    /// A specific raw term expression (e.g. `"f-06"`) and the path items that contain it.
    public struct TermExpression: Codable, Sendable, Equatable {

        enum CodingKeys: String, CodingKey {
            case termExpression = "term_expression"
            case parameters
            case pathItems      = "path_items"
        }

        /// The raw term string as it appears in file basenames (e.g. `"f-06"`).
        public let termExpression: String

        /// The parameters extracted from this term expression.
        public let parameters: [ParameterOutput]

        /// All path items whose basename contains this exact term expression.
        public let pathItems: [PathItem]
    }

    /// A single unique term and a summary of where it appears.
    public struct UniqueTerm: Codable, Sendable, Equatable {

        enum CodingKeys: String, CodingKey {
            case term
            case count
            case pathItems       = "path_items"
            case termExpressions = "term_expressions"
        }

        /// The subject of this term — full object with name, definition, and basename representation.
        public let term: Term.Subject

        /// Number of path items that contain this term. Equal to `pathItems.count`.
        public let count: Int

        /// All path items that contain this term, lexicographically sorted by `path`.
        public let pathItems: [PathItem]

        /// Grouping of path items by the specific raw term expression they contain
        /// (e.g. `"f-06"` vs `"f-08"`), sorted by `term_expression`.
        public let termExpressions: [TermExpression]
    }

    // MARK: - Properties

    enum CodingKeys: String, CodingKey {
        case cliArguments = "cli_arguments"
        case rootDir = "root_dir"
        case termUsages = "term_usages"
        case uniqueTerms = "unique_terms"
    }

    /// The full `CommandLine.arguments` array captured at invocation time.
    /// Index 0 is the binary path; index 1 is the subcommand; remaining entries are flags and values.
    public let cliArguments: [String]

    /// The directory that was crawled (value of `--dir`).
    public let rootDir: String

    /// Every path item that was crawled, paired with the terms found in its extractable portion.
    /// Items with zero terms are included when `--include-empty` is set.
    public let termUsages: [TermUsage]

    /// Deduplicated terms sorted descending by `count` (most common first).
    public let uniqueTerms: [UniqueTerm]
}
