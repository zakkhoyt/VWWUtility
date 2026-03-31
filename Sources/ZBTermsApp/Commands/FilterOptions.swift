@preconcurrency import ArgumentParser

/// Filtering options shared across all `zbterms` subcommands.
///
/// Controls which crawled items are kept or dropped before term extraction.
struct FilterOptions: ParsableArguments {

    @Option(
        name: .customLong("exclude"),
        help: ArgumentHelp(
            "Drop items whose extractable_path matches this glob. May be repeated.",
            discussion: """
            Matched against the extractable_path only (basename for files, leaf \
            directory name for dirs). Uses find -not -name semantics; wildcards * \
            and ? are supported. An item is dropped if it matches ANY pattern.

            Examples:
              --exclude "*[clip]*"                   drop items whose basename contains [clip]
              --exclude "*.tmp"                      drop temp files
              --exclude "*raw*" --exclude "*draft*"  drop raw or draft items
            """,
            valueName: "glob"
        )
    )
    var excludes: [String] = []

    @Option(
        name: .customLong("include"),
        help: ArgumentHelp(
            "Narrow results to items whose extractable_path contains this term. May be repeated.",
            discussion: """
            Applied after --exclude, in order. Each successive --include narrows the \
            result set (AND / intersection). Matching is case-insensitive substring.
            Comma-separate terms for OR within one step: --include "shoe,practice" \
            keeps items containing shoe OR practice.

            Examples:
              --include shoe                    keep items containing "shoe"
              --include shoe --include dunk     keep items with BOTH shoe AND dunk
              --include "shoe,practice"         keep items with shoe OR practice
            """,
            valueName: "term"
        )
    )
    var includes: [String] = []

    init() {}
}
