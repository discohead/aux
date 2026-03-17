import ArgumentParser

public struct APICommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "api",
        abstract: "Make raw Apple Music API requests",
        subcommands: [APIGetCommand.self, APIPostCommand.self, APIPutCommand.self, APIDeleteCommand.self]
    )
    public init() {}
}
