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
          • term_usages  — every path item paired with its extracted terms
          • unique_terms — deduplicated terms sorted by occurrence count (descending)
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

        guard let json = report.jsonDescription else {
            throw ExitCode(1)
        }
        print(json)
    }
}
