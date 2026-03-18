import ArgumentParser

public struct HistoryCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "history",
        abstract: "Access listening history and recently added content",
        subcommands: [
            HeavyRotationCommand.self,
            RecentlyPlayedStationsCommand.self,
            RecentlyAddedCommand.self,
        ]
    )
    public init() {}
}
