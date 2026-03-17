import ArgumentParser

public struct RecentlyPlayedCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "recently-played",
        abstract: "Access recently played tracks and containers",
        subcommands: [
            RecentlyPlayedTracksCommand.self,
            RecentlyPlayedContainersCommand.self,
        ]
    )
    public init() {}
}
