@preconcurrency import ArgumentParser

enum ZBTermsVersion {
    static let string = "0.1.0"
}

@main
struct ZBTerms: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "zbterms",
        abstract: "Crawl file hierarchies and operate on embedded _terms_ in filenames.",
        discussion: """
        Terms are tags embedded in filenames using underscore delimiters: _term_.
        Adjacent terms share delimiters with no doubling: _term1_term2_term3_.

        Run any subcommand with --help for details and examples.
        """,
        version: ZBTermsVersion.string,
        subcommands: [
            ReportCommand.self,
            ListUniqueCommand.self,
            RenameCommand.self,
            FindCommand.self,
        ]
    )
}
