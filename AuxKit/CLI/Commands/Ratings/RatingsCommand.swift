import ArgumentParser

public struct RatingsCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "ratings",
        abstract: "Manage track and album ratings",
        subcommands: [RatingsGetCommand.self, RatingsSetCommand.self, RatingsDeleteCommand.self]
    )
    public init() {}
}
