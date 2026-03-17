import ArgumentParser

public struct RecommendationsGroupCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "recommendations",
        abstract: "Get personalized music recommendations",
        subcommands: [
            RecommendationsListCommand.self,
        ]
    )
    public init() {}
}
