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

        Filtering:
          --exclude <pattern>  Drop items whose extractable_path matches a glob.
                               May be repeated. Uses find -not -name semantics.
          --include <term>     Keep only items whose extractable_path contains this
                               substring. May be repeated; item passes if it matches
                               any include term. Applied after all --exclude patterns.

        Examples:
          zbterms report --dir ~/videos
          zbterms report --dir ~/videos --exclude "*[clip]*"
          zbterms report --dir ~/videos --include shoe --include dunk
          zbterms report --dir ~/videos --exclude "*tmp*" --include shoe
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
            cliArguments: CommandLine.arguments,
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
