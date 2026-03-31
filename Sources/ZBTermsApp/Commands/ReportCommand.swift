@preconcurrency import ArgumentParser
import CodableUtilities
import Foundation
import ZBTermsKit

/// Crawls the hierarchy and outputs a full `TermsReport` JSON to stdout.
struct ReportCommand: AsyncParsableCommand {

    static let configuration = CommandConfiguration(
        commandName: "report",
        abstract: "Crawl a directory and report all terms found in file/dir names.",
        discussion: """
        Outputs pretty-printed, key-sorted JSON to stdout containing:
          • cli_arguments — the full invocation (binary path, subcommand, flags)
          • root_dir      — the directory that was crawled
          • term_usages   — every path item paired with its extracted terms
          • unique_terms  — deduplicated terms sorted by occurrence count (descending)

        Examples:
          zbterms report --dir ~/videos
          zbterms report --dir ~/videos --container dir
          zbterms report --dir ~/videos --exclude "*[clip]*"
          zbterms report --dir ~/videos --include shoe --include dunk
          zbterms report --dir ~/videos --exclude "*tmp*" --include "shoe,practice"
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
            cliArguments: CommandLine.arguments,
            rootDir: crawl.resolvedDir,
            pathItems: pathItems,
            includeEmpty: includeEmpty
        )

        guard let json = report.jsonDescription else {
            throw ExitCode(1)
        }
        print(json)
    }
}
