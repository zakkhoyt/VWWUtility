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
/// The subject may carry its own value via `=`: `_at=33s-for=20_` (subject `at`, value `33s`).
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
        case subjectValue = "subject_value"
        case parameters
        case syntaxVersion = "syntax_version"
    }

    /// The raw token from the basename (no surrounding `_` delimiters).
    public let raw: String

    /// The subject portion of this term.
    public let subject: Subject

    /// The subject's inline value for V2 `subject=value` terms (e.g. `33s` in `at=33s-for=20`).
    /// `nil` when the subject has no `=value`.
    public let subjectValue: String?

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

        let isV2 = basenameRepresentation.contains(BasenameDelimiters.parameterDelimiter)
            || basenameRepresentation.contains(BasenameDelimiters.optionDelimiter)
        if isV2 {
            // V2: split on '-', first part = subject (optionally `subject=value`), rest = parameters
            let parts = basenameRepresentation.split(
                separator: Character(BasenameDelimiters.parameterDelimiter),
                omittingEmptySubsequences: true
            ).map(String.init)

            let (subjectKey, subjectValue) = Term.splitOption(parts.first ?? basenameRepresentation)
            guard !subjectKey.isEmpty else { return nil }

            // UUID rejection: 8-char uppercase hex subject → this is a UUID token, not a term
            if subjectKey.range(of: #"^[A-Z0-9]{8}$"#, options: .regularExpression) != nil {
                return nil
            }

            self.subject = Term.predefinedSubjects
                .first { $0.basenameRepresentation == subjectKey }
                ?? Subject(basenameRepresentation: subjectKey)
            self.subjectValue = subjectValue

            // Predefined parameters are matched by key, so `for=20` picks up the `for` definition.
            self.parameters = parts.dropFirst().map { raw in
                let (key, _) = Term.splitOption(raw)
                guard let predefined = Term.predefinedParameters.first(where: { $0.basenameRepresentation == key }) else {
                    return Parameter(basenameRepresentation: raw)
                }
                return Parameter(basenameRepresentation: raw, name: predefined.name, definition: predefined.definition)
            }
            self.syntaxVersion = .v2
        } else {
            self.subject = Term.v1Subject(for: basenameRepresentation)
                ?? Subject(basenameRepresentation: basenameRepresentation)
            self.subjectValue = nil
            // V1 does not cleanly encode parameters — leave empty
            self.parameters = []
            self.syntaxVersion = .v1
        }
    }

    // MARK: - Parsing helpers

    /// Splits `key=value` at the first `=`. An empty value is returned as `nil`.
    static func splitOption(_ token: String) -> (key: String, value: String?) {
        guard let index = token.firstIndex(of: Character(BasenameDelimiters.optionDelimiter)) else {
            return (token, nil)
        }
        let value = String(token[token.index(after: index)...])
        return (String(token[..<index]), value.isEmpty ? nil : value)
    }

    /// Finds the predefined subject a V1 token starts with.
    ///
    /// V1 runs subject and parameters together, so the subject is found by prefix. The longest
    /// predefined prefix wins, and only when the rest of the token is empty, starts with a digit
    /// (`at30s`, `for8`), or splits entirely into predefined parameters (`shoehtred` → `shoe` +
    /// `ht` + `red`). Without those limits, ordinary words that merely start with a short subject
    /// would be misread (`foo` as `f`, `attic` as `at`).
    static func v1Subject(for token: String) -> Subject? {
        Term.predefinedSubjects
            .filter { token.hasPrefix($0.basenameRepresentation) }
            .sorted { $0.basenameRepresentation.count > $1.basenameRepresentation.count }
            .first { subject in
                let remainder = token.dropFirst(subject.basenameRepresentation.count)
                return remainder.isEmpty
                    || remainder.first?.isNumber == true
                    || isComposedOfPredefinedParameters(remainder)
            }
    }

    /// Whether `text` is a concatenation of one or more predefined parameter tokens.
    private static func isComposedOfPredefinedParameters(_ text: Substring) -> Bool {
        guard !text.isEmpty else { return true }
        return Term.predefinedParameters.contains { parameter in
            let token = parameter.basenameRepresentation
            return !token.isEmpty
                && text.hasPrefix(token)
                && isComposedOfPredefinedParameters(text.dropFirst(token.count))
        }
    }

    /// Decodes a JSON5 definitions file bundled with ZBTermsKit.
    ///
    /// These files ship inside the module, so a missing or malformed one is a programming error.
    /// Crash with the reason instead of silently returning no definitions.
    static func loadDefinitions<T: Decodable>(_ type: T.Type, resource: String) -> T {
        guard let url = Bundle.module.url(forResource: resource, withExtension: "json5") else {
            fatalError("ZBTermsKit: missing bundled resource \(resource).json5")
        }
        do {
            let decoder = JSONDecoder()
            decoder.allowsJSON5 = true
            return try decoder.decode(T.self, from: Data(contentsOf: url))
        } catch {
            fatalError("ZBTermsKit: failed to decode \(resource).json5: \(error)")
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
            Term.loadDefinitions([Subject].self, resource: "TermSubjectDefinitions")
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

        /// A parameter that keeps its raw token (e.g. `for=20`) but takes its name and
        /// definition from the predefined parameter with the same key.
        init(basenameRepresentation: String, name: String, definition: String) {
            self.basenameRepresentation = basenameRepresentation
            self.name = name
            self.definition = definition
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
            Term.loadDefinitions([Parameter].self, resource: "ParameterDefinitions")
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
