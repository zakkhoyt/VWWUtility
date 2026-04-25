import Foundation

// MARK: - BasenameRepresentable

/// Conforming types can express themselves as they appear in a file's basename.
public protocol BasenameRepresentable: Sendable {
    var basenameRepresentation: String { get }
}

// MARK: - Term

/// A single term extracted from a file's basename.
///
/// Terms are delimited by `_` characters and may contain a subject and zero or more parameters.
///
/// ## V1 syntax
/// Subject and parameters run together with no separator: `_shoehtred_`.
/// Parsing requires the predefined subject registry to split them.
///
/// ## V2 syntax
/// Subject and parameters are separated by `-`: `_shoe-ht-red_`.
/// A parameter may be a plain flag (`wood`) or a key=value option (`speed=fast`).
public struct Term: Codable, Sendable, Equatable {

    // MARK: - Static registry

    /// Subjects loaded from `TermSubjectDefinitions.json5` at first access.
    public static let predefinedSubjects: [Subject] = Subject.loadAll()

    /// Parameters loaded from `ParameterDefinitions.json5` at first access.
    public static let predefinedParameters: [Parameter] = Parameter.loadAll()

    // MARK: - Stored properties

    enum CodingKeys: String, CodingKey {
        case raw
        case subject
        case parameters
        case syntaxVersion = "syntax_version"
    }

    /// The raw token from the basename (no surrounding `_` delimiters).
    public let raw: String

    /// The subject portion of this term.
    public let subject: Subject

    /// The parameter values extracted from this term (may be empty).
    public let parameters: [Parameter]

    /// How this term was encoded in the filename.
    public let syntaxVersion: SyntaxVersion

    // MARK: - Init

    /// Creates a `Term` from a raw basename token (the text between two `_` delimiters).
    ///
    /// Returns `nil` if `basenameRepresentation` is empty.
    /// Throws `Term.Error.failedToInit` if the token contains illegal characters.
    public init?(basenameRepresentation: String) throws {
        guard !basenameRepresentation.isEmpty else { return nil }

        let illegalChars = basenameRepresentation.filter { char in
            !char.isLetter && !char.isNumber && char != "-" && char != "="
        }
        guard illegalChars.isEmpty else {
            throw Term.Error.failedToInit(
                basenameRepresentation: basenameRepresentation,
                illegalCharacters: Array(illegalChars)
            )
        }

        self.raw = basenameRepresentation

        if basenameRepresentation.contains(BasenameDelimiters.parameterDelimiter) {
            // V2: split on '-', first part = subject, rest = parameters
            let parts = basenameRepresentation.split(
                separator: Character(BasenameDelimiters.parameterDelimiter),
                omittingEmptySubsequences: true
            ).map(String.init)

            let subjectRaw = parts.first ?? basenameRepresentation

            // UUID rejection: 8-char uppercase hex subject → this is a UUID token, not a term
            if subjectRaw.range(of: #"^[A-Z0-9]{8}$"#, options: .regularExpression) != nil {
                return nil
            }

            self.subject = Term.predefinedSubjects
                .first { $0.basenameRepresentation == subjectRaw }
                ?? Subject(basenameRepresentation: subjectRaw)

            self.parameters = parts.dropFirst().map { raw in
                Term.predefinedParameters
                    .first { $0.basenameRepresentation == raw }
                    ?? Parameter(basenameRepresentation: raw)
            }
            self.syntaxVersion = .v2
        } else {
            // V1: check predefined subjects for a prefix match
            if let match = Term.predefinedSubjects.first(where: {
                basenameRepresentation.hasPrefix($0.basenameRepresentation)
            }) {
                self.subject = match
            } else {
                self.subject = Subject(basenameRepresentation: basenameRepresentation)
            }
            // V1 does not cleanly encode parameters — leave empty
            self.parameters = []
            self.syntaxVersion = .v1
        }
    }
}

// MARK: - BasenameRepresentable

extension Term: BasenameRepresentable {
    public var basenameRepresentation: String { raw }
}

// MARK: - Nested types

extension Term {

    // MARK: SyntaxVersion

    public enum SyntaxVersion: String, Codable, Sendable, Equatable {
        /// Subject and parameters run together without a separator: `shoehtred`.
        case v1
        /// Subject and parameters separated by `-`: `shoe-ht-red`.
        case v2
    }

    // MARK: BasenameDelimiters

    public struct BasenameDelimiters: Sendable {
        /// Separates terms in a file's basename.
        /// Example basename: `_bbbat-wood_turf-blue_`
        public static let termDelimiter = "_"

        /// Separates a term's subject from its parameters (V2 only).
        public static let parameterDelimiter = "-"

        /// Separates a parameter's key from its value (option-style parameters).
        /// Example: `speed=fast` inside `_modem-speed=fast_`
        public static let optionDelimiter = "="
    }

    // MARK: BasenameLocation

    public enum BasenameLocation: Sendable, Equatable {
        /// At character index 0.
        case start
        /// At the specified character index.
        case index(Int)
        /// After the last character of the existing basename (before the extension).
        case end
    }

    // MARK: Error

    public enum Error: LocalizedError {
        case failedToInit(basenameRepresentation: String, illegalCharacters: [Character])

        public var errorDescription: String? {
            switch self {
            case .failedToInit(let rep, let chars):
                let charList = chars.map { String($0) }.joined(separator: ", ")
                return "Term.init failed: '\(rep)' contains illegal characters: \(charList)"
            }
        }
    }

    // MARK: Subject

    public struct Subject: Codable, Sendable, Equatable, BasenameRepresentable {

        enum CodingKeys: String, CodingKey {
            case name
            case definition
            case basenameRepresentation = "basename_representation"
        }

        /// Common name for this subject.
        /// Example: `"Baseball Bat"`
        public let name: String

        /// A short definition as it appears in documentation or stdout/stderr.
        /// Example: `"A stick used to strike a baseball"`
        public let definition: String

        /// How this subject appears in a file's basename.
        /// Example: `"bbbat"` in `_bbbat-wood-7lb_`
        public let basenameRepresentation: String

        /// Fallback init used when no predefined subject matches the raw token.
        init(basenameRepresentation: String) {
            self.basenameRepresentation = basenameRepresentation
            self.name = basenameRepresentation
            self.definition = ""
        }

        // MARK: Resource loading

        /// Loads all predefined subjects from `TermSubjectDefinitions.json5`.
        static func loadAll() -> [Subject] {
            guard
                let url = Bundle.module.url(forResource: "TermSubjectDefinitions", withExtension: "json5"),
                let data = try? Data(contentsOf: url)
            else { return [] }
            let decoder = JSONDecoder()
            decoder.allowsJSON5 = true
            return (try? decoder.decode([Subject].self, from: data)) ?? []
        }
    }

    // MARK: Parameter

    public struct Parameter: Codable, Sendable, Equatable, BasenameRepresentable {

        enum CodingKeys: String, CodingKey {
            case name
            case definition
            case basenameRepresentation = "basename_representation"
        }

        /// Common name for this parameter.
        /// Example: `"White"`
        public let name: String

        /// A short definition as it appears in documentation or stdout/stderr.
        /// Example: `"The color white"`
        public let definition: String

        /// How this parameter appears in a file's basename.
        /// Example: `"w"` in `_shoe-w_`
        public let basenameRepresentation: String

        /// The structural type of this parameter as expressed in a basename.
        ///
        /// - `.flag`: presence-only token, e.g. `wood` in `_bbbat-wood_`.
        /// - `.option(value:)`: key=value token, e.g. `speed=fast` in `_modem-speed=fast_`.
        ///
        /// Not encoded in JSON — inferred at parse time from `basenameRepresentation`.
        public var parameterType: ParameterType {
            if let eqIdx = basenameRepresentation.firstIndex(of: Character(BasenameDelimiters.optionDelimiter)) {
                let value = String(basenameRepresentation[basenameRepresentation.index(after: eqIdx)...])
                return .option(value: value)
            }
            return .flag
        }

        /// Fallback init used when no predefined parameter matches the raw token.
        init(basenameRepresentation: String) {
            self.basenameRepresentation = basenameRepresentation
            self.name = basenameRepresentation
            self.definition = ""
        }

        // MARK: Parameter.ParameterType

        public enum ParameterType: Sendable, Equatable {
            /// A flag: present or absent.
            case flag
            /// A key=value option; `value` is the portion after `=`.
            case option(value: String)

            public var basenameRepresentation: String {
                switch self {
                case .flag: return ""
                case .option(let v): return v
                }
            }
        }

        // MARK: Resource loading

        /// Loads all predefined parameters from `ParameterDefinitions.json5`.
        static func loadAll() -> [Parameter] {
            guard
                let url = Bundle.module.url(forResource: "ParameterDefinitions", withExtension: "json5"),
                let data = try? Data(contentsOf: url)
            else { return [] }
            let decoder = JSONDecoder()
            decoder.allowsJSON5 = true
            return (try? decoder.decode([Parameter].self, from: data)) ?? []
        }
    }
}

// MARK: - [Term]: BasenameRepresentable

extension Array: @retroactive BasenameRepresentable where Element == Term {
    public var basenameRepresentation: String {
        map(\.basenameRepresentation)
            .joined(separator: Term.BasenameDelimiters.termDelimiter)
    }
}
