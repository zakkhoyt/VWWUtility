@preconcurrency import ArgumentParser
import Foundation
import ZBTermsKit

/// Options shared across all `zbterms` subcommands.
struct SharedOptions: ParsableArguments {

    @Option(
        name: .customLong("dir"),
        help: "Root directory to crawl. Defaults to the current working directory."
    )
    var dir: String?

    @Option(
        name: .customLong("max-depth"),
        help: "Maximum directory depth to descend (0 = unlimited, same as find -maxdepth)."
    )
    var maxDepth: Int = 0

    @Option(
        name: .customLong("exclude"),
        help: "Exclude path items whose extractable_path matches this glob (same semantics as find -not -name)."
    )
    var exclude: String?

    @Flag(
        name: .customLong("follow-symlinks"),
        help: "Follow symbolic links during traversal."
    )
    var followSymlinks: Bool = false

    @Flag(
        name: .customLong("dry-run"),
        help: "Print commands that would be executed without running them."
    )
    var dryRun: Bool = false

    @Flag(
        name: .customLong("debug"),
        help: "Enable verbose debug output to stderr."
    )
    var debug: Bool = false

    init() {}

    /// Resolves the effective root directory, defaulting to `$PWD`.
    var resolvedDir: String {
        if let dir {
            return dir
        }
        return FileManager.default.currentDirectoryPath
    }

    /// Validates `resolvedDir` exists and is a directory. Throws a validation error otherwise.
    func validateDir() throws {
        var isDir: ObjCBool = false
        let exists = FileManager.default.fileExists(atPath: resolvedDir, isDirectory: &isDir)
        guard exists, isDir.boolValue else {
            throw ValidationError("'\(resolvedDir)' does not exist or is not a directory.")
        }
    }

    /// Builds `FileCrawler.Options` from these shared options and a given container.
    func crawlerOptions(container: TermContainer) -> FileCrawler.Options {
        FileCrawler.Options(
            rootDir: resolvedDir,
            container: container,
            maxDepth: maxDepth,
            exclude: exclude,
            followSymlinks: followSymlinks,
            isDryRun: dryRun
        )
    }
}
