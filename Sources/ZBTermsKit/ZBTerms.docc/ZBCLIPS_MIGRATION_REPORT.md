# ZBClip Migration Plan

A plan for porting `zbclip.zsh` to Swift as new functionality in `ZBTermsKit` and a new `clip` subcommand in `zbterms`.

## Overview

`zbclip.zsh` scans a directory tree for video files whose basenames contain `_at<time>` markers, parses the timing tokens, and extracts sub-clips via `ffmpeg`. The goal of this migration is to:

1. Implement the parsing and data-model logic in `ZBTermsKit` (fully testable, no I/O).
2. Expose a `clip` subcommand in the `zbterms` binary that drives the existing `SlogBridge`/`ffmpeg` execution path.
3. Refactor `SharedOptions` into composable `@OptionGroup` structs following the ZingApp pattern, so each subcommand declares only the options it needs.

The `ffmpeg` invocation itself remains a shell command executed via `SwiftyShell`, keeping the implementation simple and the command visible in step-log output.

---

## Phase 1 — ZBTermsKit Model Layer

### New file: `Sources/ZBTermsKit/Models/TimingTerm.swift`

```swift
/// A parsed timing value derived from a `_at…_` or `_for…_` filename token.
public struct TimingTerm: Codable, Equatable, Sendable {

    /// The raw token string as it appeared in the filename, e.g. `"at2m30s"`.
    public let raw: String

    /// Resolved total seconds.
    public let seconds: Int

    // MARK: - Parsing

    /// Parses an `at`- or `for`-prefixed raw token into a `TimingTerm`.
    ///
    /// Supported formats (where N is one or more digits):
    /// - `at<N>` / `for<N>` — bare integer interpreted as seconds
    /// - `at<N>s` / `for<N>s` — explicit seconds
    /// - `at<N>m` / `for<N>m` — minutes
    /// - `at<N>m<N>s` / `for<N>m<N>s` — minutes + seconds
    public static func parse(_ raw: String) -> TimingTerm? {
        // Implementation: regex matching on the four duration variants
        let pattern = #"^(?:at|for)(\d+)m(\d+)s$|^(?:at|for)(\d+)m$|^(?:at|for)(\d+)s$|^(?:at|for)(\d+)$"#
        // ... match and compute seconds
    }
}
```

### New file: `Sources/ZBTermsKit/Models/ClipSpec.swift`

```swift
/// Describes a single clip to extract from a source file.
///
/// A `ClipSpec` is derived from a paired `_at`/`_for` token set found in a filename.
/// A single filename may yield multiple `ClipSpec` values (one per `_at` token).
public struct ClipSpec: Codable, Equatable, Sendable {

    /// Zero-based occurrence index of this `_at` token within the filename.
    public let occurrenceIndex: Int

    /// Clip start offset in the source video, in seconds.
    public let atSeconds: Int

    /// Clip duration in seconds. Either from the paired `_for` token or the fallback.
    public let forSeconds: Int

    /// Whether `forSeconds` came from a `_for` token (true) or the fallback (false).
    public let hasPairedFor: Bool
}
```

### New file: `Sources/ZBTermsKit/Core/TimingParser.swift`

```swift
/// Parses timing terms from a filename stem.
public enum TimingParser {

    /// Returns all `ClipSpec` values encoded in `stem`, split on `_`.
    ///
    /// The stem is split on `_` and scanned for `at…` tokens. Each matched
    /// `at` token is paired with an immediately following `for` token if present.
    public static func clipSpecs(
        fromStem stem: String,
        fallbackDuration: Int = 10
    ) -> [ClipSpec]

    /// Parses a single duration string.
    ///
    /// - Parameter raw: e.g. `"2m30s"`, `"4m"`, `"30s"`, `"30"`
    /// - Returns: total seconds, or `nil` if the format is unrecognized.
    public static func parseDuration(_ raw: String) -> Int?
}
```

### Updated file: `Sources/ZBTermsKit/Models/TermsReport.swift`

Add `clipSpecs` to `PathItem` (optional, only populated when the `clip` command builds the report):

```swift
public struct PathItem: Codable, Sendable {
    // existing fields …
    public let clipSpecs: [ClipSpec]   // empty for non-clip subcommands
}
```

### New file: `Sources/ZBTermsKit/Core/ClipOutputResolver.swift`

```swift
/// Resolves the output file path for a single clip.
public enum ClipOutputResolver {

    /// Builds the output basename for `occurrenceIndex` by retaining only the
    /// selected `_at/_for` pair and removing all other timing tokens.
    public static func outputBasename(
        inputBasename: String,
        spec: ClipSpec
    ) -> String

    /// Returns the full output file path.
    ///
    /// Output directory convention: `{inputDir}/{inputStem} [clips]/`
    public static func outputFilePath(
        inputFilePath: String,
        spec: ClipSpec,
        overrideOutputPath: String? = nil
    ) -> String
}
```

### Tests: `Tests/ZBTermsKitTests/TimingParserTests.swift`

```swift
class TimingParserTests: XCTestCase {
    func test_bareDigits_interpretsAsSeconds()
    func test_explicitSeconds()
    func test_minutes()
    func test_minutesAndSeconds()
    func test_multipleAtTokens_producesMultipleSpecs()
    func test_forMustFollowAt_immediately()
    func test_strayFor_ignored()
    func test_fallbackUsedWhenNoFor()
}
```

---

## Phase 2 — @OptionGroup Refactor

The current `SharedOptions` is a single flat `ParsableArguments` struct injected into all subcommands. Following the ZingApp (`HatchTerminal/Sources/ZingApp`) pattern, split it into focused option groups so subcommands declare only what they need.

### ZingApp Reference Pattern

From `HatchTerminal/Sources/ZingApp/main.swift`:

```swift
struct DeveloperArguments: ParsableArguments {
    @Flag(name: .customLong("debug"))   var isDebug = false
    @Flag(name: .customLong("dry-run")) var isDryRun = false
}

struct CommonArguments: ParsableArguments {
    @Option(name: .customLong("package-dir")) var packageDirectory: String
}

struct CreateModule: AsyncParsableCommand {
    @OptionGroup var dev: DeveloperArguments
    @OptionGroup var common: CommonArguments
    // subcommand-specific options …
}
```

### New ZBTermsApp Option Groups

#### `DeveloperArguments.swift`

```swift
/// Debug and dry-run flags shared by all subcommands.
struct DeveloperArguments: ParsableArguments {
    @Flag(name: .customLong("debug"),
          help: "Enable verbose debug output to stderr.")
    var debug = false

    @Flag(name: .customLong("dry-run"),
          help: "Print commands that would be executed without running them.")
    var dryRun = false
}
```

#### `CrawlerArguments.swift`

```swift
/// File-system traversal options used by report, list-unique, and clip.
struct CrawlerArguments: ParsableArguments {
    @Option(name: .customLong("dir"),
            help: "Root directory to crawl. Defaults to the current working directory.")
    var dir: String?

    @Option(name: .customLong("max-depth"),
            help: "Maximum directory depth (0 = unlimited).")
    var maxDepth: Int = 0

    @Option(name: .customLong("exclude"),
            help: "Exclude path items whose basename matches this glob.")
    var exclude: String?

    @Flag(name: .customLong("follow-symlinks"),
          help: "Follow symbolic links during traversal.")
    var followSymlinks = false

    var resolvedDir: String { dir ?? FileManager.default.currentDirectoryPath }

    func validateDir() throws { /* … */ }
    func crawlerOptions(container: TermContainer) -> FileCrawler.Options { /* … */ }
}
```

#### Updated `ReportCommand.swift`

```swift
struct ReportCommand: AsyncParsableCommand {
    @OptionGroup var dev: DeveloperArguments
    @OptionGroup var crawler: CrawlerArguments

    @Argument(help: "What to mine: file (default), dir, or all.")
    var container: TermContainer = .file

    @Flag(name: .customLong("include-empty"), …)
    var includeEmpty = false

    func run() async throws {
        SlogBridge.shared.isDebug = dev.debug
        await SlogBridge.shared.probe()
        try crawler.validateDir()
        // …
    }
}
```

Apply the same split to `ListUniqueCommand` and `RenameCommand`. Remove the now-superseded `SharedOptions.swift`.

---

## Phase 3 — `clip` Subcommand

### New file: `Sources/ZBTermsApp/Commands/ClipCommand.swift`

```swift
import ArgumentParser
import Foundation
import ZBTermsKit

/// Scans for files with `_at<time>` markers and extracts clips via ffmpeg.
struct ClipCommand: AsyncParsableCommand {

    static let configuration = CommandConfiguration(
        commandName: "clip",
        abstract: "Extract video clips marked with _at and _for timing tokens.",
        discussion: """
        Scans the directory for files whose basename contains _at followed by one or
        more digits. For each match, derives the start offset and duration, then
        invokes ffmpeg to extract the clip.

        Duration precedence: _for in filename > --duration > default 10s.

        Each output clip is written to a sibling subdirectory named:
          {source-stem} [clips]/

        Use --dry-run to preview the ffmpeg commands without extracting clips.

        Examples:
          zbterms clip --dir ~/videos
          zbterms clip --dir ~/videos --duration 5s --include shoe --dry-run
        """
    )

    // MARK: - Option Groups

    @OptionGroup var dev: DeveloperArguments
    @OptionGroup var crawler: CrawlerArguments

    // MARK: - Clip-specific Options

    @Option(
        name: .customLong("duration"),
        help: "Fallback clip duration when _for is absent. Formats: <N>, <N>s, <N>m, <N>m<N>s. Default: 10s."
    )
    var duration: String = "10s"

    @Option(
        name: .customLong("output"),
        help: "Override output path strategy. Omit to use {source-dir}/{source-stem} [clips]/."
    )
    var output: String?

    @Option(
        name: .customLong("exclude"),
        help: "Exclude basenames containing this substring (repeatable).",
        transform: { $0 }
    )
    var excludeTerms: [String] = []

    @Option(
        name: .customLong("include"),
        help: "Require basenames to contain this substring (repeatable).",
        transform: { $0 }
    )
    var includeTerms: [String] = []

    @Option(
        name: .customLong("scan-format"),
        help: "Output format for the scan report: json (default) or jsonl."
    )
    var scanFormat: ScanFormat = .json

    // MARK: - Run

    func run() async throws {
        SlogBridge.shared.isDebug = dev.debug
        await SlogBridge.shared.probe()
        try crawler.validateDir()

        guard let fallbackSeconds = TimingParser.parseDuration(duration) else {
            throw ValidationError("Invalid --duration value: '\(duration)'")
        }

        let scanDir = crawler.resolvedDir
        let paths = try await findCandidatePaths(under: scanDir)

        var records: [ClipRecord] = []

        for path in paths {
            let basename = URL(fileURLWithPath: path).lastPathComponent
            guard passes(basename: basename) else { continue }

            let specs = TimingParser.clipSpecs(
                fromStem: URL(fileURLWithPath: basename).deletingPathExtension().lastPathComponent,
                fallbackDuration: fallbackSeconds
            )
            guard !specs.isEmpty else { continue }

            for spec in specs {
                let outputFilePath = ClipOutputResolver.outputFilePath(
                    inputFilePath: path,
                    spec: spec,
                    overrideOutputPath: output
                )
                let isNew = try await extractClip(
                    inputPath: path,
                    spec: spec,
                    outputPath: outputFilePath
                )
                records.append(ClipRecord(
                    relativePath: path,
                    basename: basename,
                    atSeconds: spec.atSeconds,
                    forSeconds: spec.forSeconds,
                    outputFilePath: outputFilePath,
                    isNew: isNew
                ))
            }
        }

        printOutput(records)
    }

    // MARK: - Private helpers

    /// Runs `find <scanDir> -type f -name '*_at[0-9]*'` via SlogBridge.
    private func findCandidatePaths(under dir: String) async throws -> [String] { /* … */ }

    /// Applies --include / --exclude filters against the basename.
    private func passes(basename: String) -> Bool { /* … */ }

    /// Invokes ffmpeg via SlogBridge.runStep, returns true if clip was created.
    private func extractClip(
        inputPath: String,
        spec: ClipSpec,
        outputPath: String
    ) async throws -> Bool { /* … */ }

    private func printOutput(_ records: [ClipRecord]) { /* … */ }
}

enum ScanFormat: String, ExpressibleByArgument {
    case json, jsonl
}
```

### `ClipRecord` (internal to ZBTermsApp or ZBTermsKit)

```swift
struct ClipRecord: Codable {
    let relativePath: String
    let basename: String
    let atSeconds: Int
    let forSeconds: Int
    let outputFilePath: String
    let isNew: Bool

    enum CodingKeys: String, CodingKey {
        case relativePath = "relative_path"
        case basename
        case atSeconds = "at_seconds"
        case forSeconds = "for_seconds"
        case outputFilePath = "output_filepath"
        case isNew = "new"
    }
}
```

### Register in `ZBTermsApp.swift`

```swift
@main
struct ZBTerms: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "zbterms",
        abstract: "Crawl file hierarchies and operate on embedded _terms_ in filenames.",
        subcommands: [
            ReportCommand.self,
            ListUniqueCommand.self,
            RenameCommand.self,
            ClipCommand.self,          // ← new
        ]
    )
}
```

---

## Phase 4 — ffmpeg Integration via SwiftyShell

`ClipCommand.extractClip(…)` should build the ffmpeg command as a `String` and pass it through `SlogBridge.shared.runStep(…)`, exactly as `RenameCommand` builds `mv` commands.

### ffmpeg Command Template

```swift
private func ffmpegCommand(
    inputPath: String,
    startOffset: Int,
    duration: Int,
    outputPath: String
) -> String {
    let args: [String] = [
        "ffmpeg",
        "-nostdin", "-hide_banner",
        "-loglevel", "warning",
        "-stats_period", "1", "-stats",
        "-ss", "\(startOffset)",
        "-i", shellQuote(inputPath),
        "-t", "\(duration)",
        "-map", "0:v:0", "-map", "0:a:0?",
        "-codec:v", "libx264",
        "-preset", "medium",
        "-crf", "18",
        "-pix_fmt", "yuv420p",
        "-codec:a", "aac",
        "-b:a", "192k",
        "-movflags", "+faststart",
        "-y",
        shellQuote(outputPath),
    ]
    return args.joined(separator: " ")
}
```

The `mkdir -p` for the output directory should be a **separate** preceding `runStep` call so both commands appear in the step log.

### Skip-if-Exists Logic

Check for the output file's existence in Swift before calling `runStep`. If the file exists, emit an info-level log via `SlogBridge.shared.info(…)` and record `isNew = false` — matching the `zbclip.zsh` exit-code-10 pattern without requiring a shell-level exit code.

---

## Package.swift Changes

No new package dependencies are required. `ZBTermsKit` already depends on `SwiftyShell`, and `ZBTermsApp` already depends on `ArgumentParser` and `ZBTermsKit`.

The only additions:

```swift
// Tests target — add new test files
.testTarget(
    name: "ZBTermsKitTests",
    dependencies: ["ZBTermsKit"]
    // TimingParserTests.swift, ClipOutputResolverTests.swift
),
```

---

## Implementation Order

| Step | Target       | Work                                              |
| ---- | ------------ | ------------------------------------------------- |
| 1    | ZBTermsKit   | `TimingTerm`, `ClipSpec`, `TimingParser`           |
| 2    | ZBTermsKit   | `ClipOutputResolver`                              |
| 3    | ZBTermsKitTests | `TimingParserTests`, `ClipOutputResolverTests`  |
| 4    | ZBTermsApp   | Split `SharedOptions` → `DeveloperArguments` + `CrawlerArguments` |
| 5    | ZBTermsApp   | Update `ReportCommand`, `ListUniqueCommand`, `RenameCommand` to use new groups |
| 6    | ZBTermsApp   | `ClipCommand` + `ScanFormat` + `ClipRecord`       |
| 7    | ZBTermsApp   | Register `ClipCommand` in `ZBTermsApp.swift`      |
| 8    | Integration  | Manual smoke-test on real media library           |

---

## Smoke Test Commands

```zsh
# Build
swift build --product zbterms

# Preview (dry-run) — should print ffmpeg commands, no files written
.build/debug/zbterms clip --dir ~/videos --dry-run

# Live extraction with debug output
.build/debug/zbterms clip --dir ~/videos --debug 2>&1 | head -80

# Include/exclude filters
.build/debug/zbterms clip --dir ~/videos --include shoe --exclude clip --dry-run

# JSON output
.build/debug/zbterms clip --dir ~/videos --scan-format json --dry-run

# Custom fallback duration
.build/debug/zbterms clip --dir ~/videos --duration 30s --dry-run
```

---

## Out of Scope

- Audio-only clip extraction (no `-map 0:a:0` without video track)
- Re-encoding presets beyond the current libx264 / aac 192k settings
- Thumbnail extraction
- VR / 180° / 360° video handling (separate tooling)
- Batch progress reporting / ETA
- Phase 3 favorite-rating migration (`_f{NN}_` conversion)
