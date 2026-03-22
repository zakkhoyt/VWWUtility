import Foundation

/// Builds a `TermsReport` from a crawled set of `PathItem`s.
public enum TermsReportBuilder {

    // MARK: - Public API

    /// Builds a complete `TermsReport` from the given path items.
    ///
    /// - Parameters:
    ///   - rootDir: The directory that was crawled (`--dir`).
    ///   - pathItems: Items returned by `FileCrawler.crawl(options:)`.
    ///   - includeEmpty: When `false` (default), items with zero terms are excluded from
    ///     `termUsages`. They are never counted toward `uniqueTerms`.
    /// - Returns: A fully populated `TermsReport`.
    public static func build(
        rootDir: String,
        pathItems: [TermsReport.PathItem],
        includeEmpty: Bool = false
    ) -> TermsReport {
        // Build term usages
        var termUsages: [TermsReport.TermUsage] = []
        // Accumulate: term → [PathItem]
        var termToItems: [String: [TermsReport.PathItem]] = [:]

        for item in pathItems {
            let terms = TermExtractor.extractTerms(from: item.extractablePath)
            if !includeEmpty && terms.isEmpty { continue }

            termUsages.append(TermsReport.TermUsage(pathItem: item, terms: terms))

            for term in terms {
                termToItems[term, default: []].append(item)
            }
        }

        // Build unique terms sorted descending by count, then alphabetically by term
        let uniqueTerms = termToItems
            .map { term, items -> TermsReport.UniqueTerm in
                let sorted = items.sorted { $0.path < $1.path }
                return TermsReport.UniqueTerm(term: term, count: items.count, pathItems: sorted)
            }
            .sorted {
                if $0.count != $1.count { return $0.count > $1.count }
                return $0.term < $1.term
            }

        return TermsReport(
            rootDir: rootDir,
            termUsages: termUsages,
            uniqueTerms: uniqueTerms
        )
    }
}
