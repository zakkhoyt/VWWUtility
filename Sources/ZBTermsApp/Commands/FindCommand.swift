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
          • One relative file path per line (relative to --dir)
          • Sorted by path

        When --debug is set, the full JSON report is printed instead (identical to `report`).

        Filtering:
          --exclude <pattern>  Drop items whose extractable_path matches a glob.
                               May be repeated. Uses find -not -name semantics.
          --include <term>     Keep only items whose extractable_path contains this
                               substring. May be repeated; item passes if it matches
                               any include term. Applied after all --exclude patterns.

        Examples:
          zbterms find --dir ~/videos
          zbterms find --dir ~/videos --include shoe
          zbterms find --dir ~/videos --include shoe --include dunk
          zbterms find --dir ~/videos --exclude "*[clip]*" --include shoe
          zbterms find --dir ~/videos --debug   # full JSON report
        """
    )

    @OptionGroup
    var shared: SharedOptions

    @Argument(
        help: "What to mine: file (default), dir, or all."
    )
    var container: TermContainer = .file

    init() {}

    func run() async throws {
        try shared.validateDir()
        SlogBridge.shared.isDebug = shared.debug
        await SlogBridge.shared.probe()

        let options = shared.crawlerOptions(container: container)
        let pathItems = try await FileCrawler.crawl(options: options)

        if shared.debug {
            // Full JSON report — identical to `report` command output
            let report = TermsReportBuilder.build(
                cliArguments: CommandLine.arguments,
                rootDir: shared.resolvedDir,
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
