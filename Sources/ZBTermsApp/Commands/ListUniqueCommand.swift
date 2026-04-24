@preconcurrency import ArgumentParser
import Foundation
import ZBTermsKit

/// Crawls the hierarchy and outputs only the `unique_terms` array as JSON.
struct ListUniqueCommand: AsyncParsableCommand {

    static let configuration = CommandConfiguration(
        commandName: "list-unique",
        abstract: "List all unique terms found in the hierarchy, sorted by occurrence count.",
        discussion: """
        Outputs a JSON array of unique term objects, sorted by count descending. Each entry:
          • term        — the term string (without surrounding underscores)
          • count       — number of path items that contain this term
          • path_items  — list of path items containing the term (lex sorted)

        Examples:
          zbterms list-unique --dir ~/videos
          zbterms list-unique --dir ~/videos --include shoe
          zbterms list-unique --dir ~/videos --exclude "*[clip]*" --max-depth 2
        """,
        version: ZBTermsVersion.string
    )

    @OptionGroup var crawl: CrawlOptions
    @OptionGroup var filter: FilterOptions
    @OptionGroup var developer: DeveloperOptions

    @Argument(
        help: ArgumentHelp(
            "Scope of items to mine: file (default), dir, or all.",
            valueName: "file|dir|all"
        )
    )
    var container: TermContainer = .file

    @Flag(
        name: .customLong("include-empty"),
        help: ArgumentHelp(
            "Include path items that contain zero terms.",
            discussion: "By default, items with no extractable terms are omitted from the report."
        )
    )
    var includeEmpty: Bool = false

    init() {}

    func run() async throws {
        try crawl.validateDir()
        SlogBridge.shared.isDebug = developer.debug
        await SlogBridge.shared.probe()

        let options = crawl.crawlerOptions(container: container, filter: filter, developer: developer)
        let pathItems = try await FileCrawler.crawl(options: options)

        let report = TermsReportBuilder.build(
            rootDir: crawl.resolvedDir,
            pathItems: pathItems,
            includeEmpty: includeEmpty
        )

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(report.uniqueTerms)
        guard let json = String(data: data, encoding: .utf8) else {
            throw ExitCode(1)
        }
        print(json)
    }
}
