import Foundation
import SwiftyShell

/// Crawls a directory hierarchy using `find` (via SwiftyShell) and produces `PathItem` records.
///
/// Each crawl call composes and logs the exact `find` command used, so users can copy-paste it
/// for debugging. The step logging is performed by `SlogBridge`.
public enum FileCrawler {

    // MARK: - Public API

    /// Options that control what `find` searches for.
    public struct Options {
        /// The root directory to crawl.
        public let rootDir: String
        /// What types of entries to mine: files, directories, or both.
        public let container: TermContainer
        /// Maximum directory depth. `0` means unlimited (no `-maxdepth` flag).
        public let maxDepth: Int
        /// Glob pattern to exclude from results (matched against `extractable_path`).
        public let exclude: String?
        /// Whether to follow symbolic links.
        public let followSymlinks: Bool
        /// Whether to emit dry-run logging instead of executing.
        public let isDryRun: Bool

        public init(
            rootDir: String,
            container: TermContainer = .file,
            maxDepth: Int = 0,
            exclude: String? = nil,
            followSymlinks: Bool = false,
            isDryRun: Bool = false
        ) {
            self.rootDir = rootDir
            self.container = container
            self.maxDepth = maxDepth
            self.exclude = exclude
            self.followSymlinks = followSymlinks
            self.isDryRun = isDryRun
        }
    }

    /// Crawls the hierarchy described by `options` and returns `PathItem` records.
    ///
    /// Each `PathItem` contains the relative path, the `extractable_path` portion (from which
    /// terms should be mined), and the absolute path.
    ///
    /// - Parameter options: Crawl configuration.
    /// - Returns: `PathItem` array in the order `find` returns results.
    public static func crawl(options: Options) async throws -> [TermsReport.PathItem] {
        var items: [TermsReport.PathItem] = []

        let containers: [TermContainer] = options.container == .all ? [.file, .dir] : [options.container]

        for container in containers {
            let findItems = try await runFind(options: options, container: container)
            items.append(contentsOf: findItems)
        }

        return items
    }

    // MARK: - Private helpers

    private static func runFind(
        options: Options,
        container: TermContainer
    ) async throws -> [TermsReport.PathItem] {
        let findCmd = buildFindCommand(options: options, container: container)
        let rootURL = URL(fileURLWithPath: options.rootDir, isDirectory: true)

        let lines = try await SlogBridge.shared.runStep(
            will: "crawl \(container.rawValue)s under \(options.rootDir)",
            command: findCmd,
            successMessage: "crawl complete",
            isDryRun: options.isDryRun
        )

        if options.isDryRun { return [] }

        return lines.compactMap { absolutePath -> TermsReport.PathItem? in
            guard !absolutePath.isEmpty else { return nil }

            // Make path relative to rootDir
            let relPath = URL(fileURLWithPath: absolutePath)
                .pathRelative(to: rootURL)

            let contentType: TermsReport.PathContentType = container == .file ? .file : .dir

            // extractable_path: basename for files, last path component for dirs
            let extractable: String
            switch container {
            case .file:
                extractable = URL(fileURLWithPath: absolutePath).lastPathComponent
            case .dir:
                extractable = URL(fileURLWithPath: absolutePath).lastPathComponent
            case .all:
                extractable = URL(fileURLWithPath: absolutePath).lastPathComponent
            }

            return TermsReport.PathItem(
                pathContentType: contentType,
                path: relPath,
                extractablePath: extractable,
                absolutePath: absolutePath
            )
        }
    }

    /// Builds the `find` command string for a given container type.
    private static func buildFindCommand(options: Options, container: TermContainer) -> String {
        var parts = ["find"]

        // Symlink flag must come before the path on macOS
        if options.followSymlinks {
            parts.append("-L")
        }

        parts.append(shellQuote(options.rootDir))

        // Depth limit
        if options.maxDepth > 0 {
            parts += ["-maxdepth", "\(options.maxDepth)"]
        }

        // Type filter
        switch container {
        case .file:
            parts += ["-type", "f"]
        case .dir:
            parts += ["-type", "d", "!", "-path", shellQuote(options.rootDir)]
        case .all:
            // Handled by running two separate find calls; this branch is unreachable here.
            break
        }

        // Exclude filter (matches against basename, like find -name)
        if let exclude = options.exclude {
            parts += ["!", "-name", shellQuote(exclude)]
        }

        return parts.joined(separator: " ")
    }

    private static func shellQuote(_ s: String) -> String {
        "'" + s.replacingOccurrences(of: "'", with: "'\\''") + "'"
    }
}

// MARK: - URL path helpers

private extension URL {
    /// Returns the path of `self` relative to `base`, or the absolute path if not under `base`.
    func pathRelative(to base: URL) -> String {
        let basePath = base.standardized.path
        let selfPath = standardized.path
        if selfPath.hasPrefix(basePath + "/") {
            return String(selfPath.dropFirst(basePath.count + 1))
        }
        return selfPath
    }
}
