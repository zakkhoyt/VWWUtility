import Foundation

/// Builds a `TermsReport` from a crawled set of `PathItem`s.
public enum TermsReportBuilder {

    // MARK: - Public API

    /// Builds a complete `TermsReport` from the given path items.
    ///
    /// - Parameters:
    ///   - cliArguments: The full `CommandLine.arguments` captured at invocation time.
    ///   - rootDir: The directory that was crawled (`--dir`).
    ///   - pathItems: Items returned by `FileCrawler.crawl(options:)`.
    ///   - includeEmpty: When `false` (default), items with zero terms are excluded from
    ///     `termUsages`. They are never counted toward `uniqueTerms`.
    /// - Returns: A fully populated `TermsReport`.
    public static func build(
        cliArguments: [String] = [],
        rootDir: String,
        pathItems: [TermsReport.PathItem],
        includeEmpty: Bool = false
    ) -> TermsReport {
        // Build term usages
        var termUsages: [TermsReport.TermUsage] = []
        // subject BR → all items for that subject
        var termToItems:     [String: [TermsReport.PathItem]] = [:]
        // subject BR → Subject object (captured once per subject)
        var subjectByBR:     [String: Term.Subject]           = [:]
        // subject BR → set of raw term strings seen under it
        var subjectToRaws:   [String: Set<String>]            = [:]
        // raw term → items containing that exact raw term
        var rawToItems:      [String: [TermsReport.PathItem]] = [:]
        // raw term → parameters (stable; first occurrence wins)
        var rawToParameters: [String: [Term.Parameter]]       = [:]

        for item in pathItems {
            let terms = TermExtractor.extractTerms(from: item.extractablePath)
            if !includeEmpty && terms.isEmpty { continue }

            termUsages.append(TermsReport.TermUsage(pathItem: item, terms: terms))

            for term in terms {
                let br = term.subject.basenameRepresentation
                subjectByBR[br]                     = term.subject
                termToItems[br, default: []].append(item)
                subjectToRaws[br, default: []].insert(term.raw)
                rawToItems[term.raw, default: []].append(item)
                if rawToParameters[term.raw] == nil {
                    rawToParameters[term.raw] = term.parameters
                }
            }
        }

        // Build unique terms sorted descending by count, then alphabetically by subject
        let uniqueTerms = termToItems
            .map { br, items -> TermsReport.UniqueTerm in
                let subject = subjectByBR[br]!
                let termExpressions = (subjectToRaws[br] ?? []).sorted().map { raw in
                    TermsReport.TermExpression(
                        termExpression: raw,
                        parameters: (rawToParameters[raw] ?? []).map {
                            TermsReport.ParameterOutput(from: $0)
                        },
                        pathItems: (rawToItems[raw] ?? []).sorted { $0.path < $1.path }
                    )
                }
                return TermsReport.UniqueTerm(
                    term: subject,
                    count: items.count,
                    pathItems: items.sorted { $0.path < $1.path },
                    termExpressions: termExpressions
                )
            }
            .sorted {
                if $0.count != $1.count { return $0.count > $1.count }
                return $0.term.basenameRepresentation < $1.term.basenameRepresentation
            }

        return TermsReport(
            cliArguments: cliArguments,
            rootDir: rootDir,
            termUsages: termUsages,
            uniqueTerms: uniqueTerms
        )
    }
}
