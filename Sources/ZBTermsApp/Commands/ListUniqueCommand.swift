@preconcurrency import ArgumentParser
import Foundation
import ZBTermsKit

/// Crawls the hierarchy and outputs only the `unique_terms` array as JSON.
struct ListUniqueCommand: AsyncParsableCommand {

    static let configuration = CommandConfiguration(
        commandName: "list-unique",
        abstract: "List all unique terms found in the hierarchy, sorted by occurrence count.",
        discussion: """
        Outputs a JSON array of unique term objects. Each entry contains:
          • term        — the term string (without surrounding underscores)
          • count       — number of path items that contain this term
          • path_items  — list of path items containing the term (lex sorted)

        Accepts the same options as the `report` command.
        """
    )

    @OptionGroup
    var shared: SharedOptions

    @Argument(
        help: "What to mine: file (default), dir, or all."
    )
    var container: TermContainer = .file

    @Flag(
        name: .customLong("include-empty"),
        help: "Include path items that contain zero terms."
    )
    var includeEmpty: Bool = false

    init() {}

    func run() async throws {
        try shared.validateDir()
        SlogBridge.shared.isDebug = shared.debug
        await SlogBridge.shared.probe()

        let options = shared.crawlerOptions(container: container)
        let pathItems = try await FileCrawler.crawl(options: options)

        let report = TermsReportBuilder.build(
            rootDir: shared.resolvedDir,
            pathItems: pathItems,
            includeEmpty: includeEmpty
        )

        // Output only the uniqueTerms array
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(report.uniqueTerms)
        guard let json = String(data: data, encoding: .utf8) else {
            throw ExitCode(1)
        }
        print(json)
    }
}
