@preconcurrency import ArgumentParser
import Foundation
import ZBTermsKit

/// Renames files or directories matching `--old` to a new name derived from `--new`.
///
/// Operates without regard to term structure — purely string/glob replacement.
struct RenameCommand: AsyncParsableCommand {

    static let configuration = CommandConfiguration(
        commandName: "rename",
        abstract: "Rename files or directories matching a glob pattern.",
        discussion: """
        Finds entries whose name matches --old (glob, same as find -name) and renames them
        so that the matched portion becomes --new.  The --old and --new patterns support * wildcards.

        Use --dry-run to preview what would be renamed without making changes.

        Examples:
          zbterms rename --old "*_test_*" --new "*_demo_*" --dir ~/videos
          zbterms rename --old "*_shoe_*" --new "*_sneaker_*" --dry-run
        """
    )

    @OptionGroup
    var shared: SharedOptions

    @Argument(
        help: "What to rename: file (default), dir, or all."
    )
    var container: TermContainer = .file

    @Option(
        name: .customLong("old"),
        help: "Glob pattern that selects entries to rename (matched against basename)."
    )
    var old: String

    @Option(
        name: .customLong("new"),
        help: "Replacement pattern for the new basename."
    )
    var new: String

    init() {}

    func run() async throws {
        try shared.validateDir()
        SlogBridge.shared.isDebug = shared.debug
        await SlogBridge.shared.probe()

        let rootDir = shared.resolvedDir
        let findCmd = buildFindCommand(rootDir: rootDir)

        // Find matching paths
        let matchingPaths = try await SlogBridge.shared.runStep(
            will: "find entries matching '\(old)' under \(rootDir)",
            command: findCmd,
            successMessage: "found matching entries",
            isDryRun: false // always run find even in dry-run; just skip the mv
        )

        guard !matchingPaths.isEmpty else {
            await SlogBridge.shared.info("no entries matched pattern '\(old)' under \(rootDir)")
            return
        }

        // Rename each match
        for absolutePath in matchingPaths {
            let url = URL(fileURLWithPath: absolutePath)
            let basename = url.lastPathComponent
            let newBasename = applyRenamePattern(basename: basename, old: old, new: new)
            let newURL = url.deletingLastPathComponent().appendingPathComponent(newBasename)

            let mvCmd = "mv \(shellQuote(absolutePath)) \(shellQuote(newURL.path))"

            try await SlogBridge.shared.runStep(
                will: "rename '\(basename)' → '\(newBasename)'",
                command: mvCmd,
                isDryRun: shared.dryRun
            )
        }
    }

    // MARK: - Helpers

    private func buildFindCommand(rootDir: String) -> String {
        var parts = ["find"]

        if shared.followSymlinks {
            parts.append("-L")
        }

        parts.append(shellQuote(rootDir))

        if shared.maxDepth > 0 {
            parts += ["-maxdepth", "\(shared.maxDepth)"]
        }

        switch container {
        case .file:
            parts += ["-type", "f"]
        case .dir:
            parts += ["-type", "d", "!", "-path", shellQuote(rootDir)]
        case .all:
            break // find without -type returns both
        }

        parts += ["-name", shellQuote(old)]

        if let exclude = shared.exclude {
            parts += ["!", "-name", shellQuote(exclude)]
        }

        return parts.joined(separator: " ")
    }

    /// Applies `--old` → `--new` replacement on `basename`.
    ///
    /// Converts the glob `old` pattern to a regex, finds the match in `basename`,
    /// then substitutes with the literal text derived from `new` (with `*` preserved as-is
    /// from the captured group).
    private func applyRenamePattern(basename: String, old: String, new: String) -> String {
        // Simple approach: replace exact substring occurrences of the non-wildcard parts.
        // For patterns like "*_shoe_*" → "*_sneaker_*", extract the literal middle portion.
        let oldLiteral = extractLiteral(from: old)
        let newLiteral = extractLiteral(from: new)

        guard !oldLiteral.isEmpty else { return basename }
        return basename.replacingOccurrences(of: oldLiteral, with: newLiteral)
    }

    /// Strips leading/trailing `*` wildcards and returns the literal core of a glob pattern.
    private func extractLiteral(from glob: String) -> String {
        var s = glob
        while s.hasPrefix("*") { s = String(s.dropFirst()) }
        while s.hasSuffix("*") { s = String(s.dropLast()) }
        return s
    }

    private func shellQuote(_ s: String) -> String {
        "'" + s.replacingOccurrences(of: "'", with: "'\\''") + "'"
    }
}
