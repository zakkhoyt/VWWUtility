@preconcurrency import ArgumentParser
import CodableUtilities
import Foundation
import ZBTermsKit

/// Syntax sugar over `report` that outputs one relative filepath per line.
///
/// When `--debug` is set, outputs the full JSON report instead.
struct FindCommand: AsyncParsableCommand {

    static let configuration = CommandConfiguration(
        commandName: "find",
        abstract: "Find files/dirs that contain _terms_, printing one relative path per line.",
        discussion: """
        Runs the same pipeline as `report` but formats output as plain text:
          • One relative path per line (relative to --dir), sorted
          • Pipeline-friendly: output can be piped to xargs, fzf, etc.

        When --debug is set, the full JSON report is printed instead (same as `report`).

        Examples:
          zbterms find --dir ~/videos
          zbterms find --dir ~/videos --include shoe
          zbterms find --dir ~/videos --include shoe --include dunk
          zbterms find --dir ~/videos --exclude "*[clip]*" --include shoe
          zbterms find --dir ~/videos | fzf
          zbterms find --dir ~/videos --debug   # full JSON report
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

    init() {}

    func run() async throws {
        try crawl.validateDir()
        SlogBridge.shared.isDebug = developer.debug
        await SlogBridge.shared.probe()

        let options = crawl.crawlerOptions(container: container, filter: filter, developer: developer)
        let pathItems = try await FileCrawler.crawl(options: options)

        if developer.debug {
            // Full JSON report — identical to `report` command output
            let report = TermsReportBuilder.build(
                cliArguments: CommandLine.arguments,
                rootDir: crawl.resolvedDir,
                pathItems: pathItems,
                includeEmpty: false
            )
            guard let json = report.jsonDescription else {
                throw ExitCode(1)
            }
            print(json)
        } else {
            // Plain text: one relative path per line, sorted
            let paths = pathItems
                .map(\.path)
                .sorted()
            for path in paths {
                print(path)
            }
        }
    }
}
