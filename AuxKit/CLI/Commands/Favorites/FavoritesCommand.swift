import ArgumentParser

public struct FavoritesCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "favorites",
        abstract: "Manage Apple Music favorites",
        subcommands: [FavoritesAddCommand.self]
    )
    public init() {}
}
