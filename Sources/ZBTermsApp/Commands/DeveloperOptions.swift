@preconcurrency import ArgumentParser

/// Developer/execution options shared across all `zbterms` subcommands.
///
/// Controls debug verbosity and dry-run mode.
struct DeveloperOptions: ParsableArguments {

    @Flag(
        name: .customLong("debug"),
        help: ArgumentHelp(
            "Enable verbose debug output to stderr.",
            discussion: """
            Emits slog_step_se decorated output for each major operation: find \
            command, filter steps, and any shell invocations. Goes to stderr so \
            it does not interfere with JSON stdout.
            """
        )
    )
    var debug: Bool = false

    @Flag(
        name: .customLong("dry-run"),
        help: ArgumentHelp(
            "Print commands that would be executed without running them.",
            discussion: "Mutating operations (mv, mkdir) are logged to stderr but skipped."
        )
    )
    var dryRun: Bool = false

    init() {}
}
