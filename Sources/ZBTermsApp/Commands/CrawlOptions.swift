@preconcurrency import ArgumentParser
import Foundation
import ZBTermsKit

/// Traversal options shared across all `zbterms` subcommands.
///
/// Controls which directory is crawled, how deep to descend, and whether to follow symlinks.
struct CrawlOptions: ParsableArguments {

    @Option(
        name: .customLong("dir"),
        help: ArgumentHelp(
            "Root directory to crawl.",
            discussion: "Defaults to the current working directory. Tildes and symlinks are resolved.",
            valueName: "path"
        )
    )
    var dir: String?

    @Option(
        name: .customLong("max-depth"),
        help: ArgumentHelp(
            "Maximum directory depth to descend (0 = unlimited).",
            discussion: "Maps to find -maxdepth. Depth 1 sees only the immediate children of --dir.",
            valueName: "n"
        )
    )
    var maxDepth: Int = 0

    @Flag(
        name: .customLong("follow-symlinks"),
        help: ArgumentHelp(
            "Follow symbolic links during traversal.",
            discussion: "Maps to find -L. Beware cycles in symlink trees."
        )
    )
    var followSymlinks: Bool = false

    init() {}

    /// Resolves the effective root directory, defaulting to `$PWD`.
    /// Expands tildes, resolves symlinks, and normalizes the path.
    var resolvedDir: String {
        let raw = dir ?? FileManager.default.currentDirectoryPath
        return raw.easyDirURL.path
    }

    /// Validates `resolvedDir` exists and is a directory. Throws a `ValidationError` otherwise.
    func validateDir() throws {
        var isDir: ObjCBool = false
        let exists = FileManager.default.fileExists(atPath: resolvedDir, isDirectory: &isDir)
        guard exists, isDir.boolValue else {
            throw ValidationError("'\(resolvedDir)' does not exist or is not a directory.")
        }
    }

    /// Builds `FileCrawler.Options` from traversal, filter, and developer settings.
    func crawlerOptions(
        container: TermContainer,
        filter: FilterOptions,
        developer: DeveloperOptions
    ) -> FileCrawler.Options {
        FileCrawler.Options(
            rootDir: resolvedDir,
            container: container,
            maxDepth: maxDepth,
            excludes: filter.excludes,
            includes: filter.includes,
            followSymlinks: followSymlinks,
            isDryRun: developer.dryRun
        )
    }
}
