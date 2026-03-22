@preconcurrency import ArgumentParser

@main
struct ZBTerms: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "zbterms",
        abstract: "Crawl file hierarchies and operate on embedded _terms_ in filenames.",
        subcommands: [
            ReportCommand.self,
            ListUniqueCommand.self,
            RenameCommand.self,
            FindCommand.self,
        ]
    )
}
