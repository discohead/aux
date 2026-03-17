import ArgumentParser

public struct SearchAlbumsCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "albums",
        abstract: "Search for albums in the Apple Music catalog"
    )

    @Argument(help: "Search query") var query: String
    @Option(name: .long, help: "Maximum results") var limit: Int = 25
    @Option(name: .long, help: "Results offset") var offset: Int = 0
    @Flag(name: .long, help: "Pretty-print JSON") var pretty = false
    @Flag(name: .long, help: "Suppress non-JSON output") var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        let services = ServiceContainer.live()
        try await SearchAlbumsHandler.handle(services: services, options: options, query: query, limit: limit, offset: offset)
    }
    public init() {}
}
