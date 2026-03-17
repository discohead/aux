import ArgumentParser

public struct AuthCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "auth",
        abstract: "Manage Apple Music authorization",
        subcommands: [
            AuthStatusCommand.self,
            AuthRequestCommand.self,
            AuthTokenCommand.self,
        ]
    )
    public init() {}
}
