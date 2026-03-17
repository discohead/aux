import ArgumentParser

public struct SearchAllCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "all",
        abstract: "Search all types in the Apple Music catalog"
    )

    @Argument(help: "Search query") var query: String
    @Option(name: .long, help: "Resource types to search (comma-separated)") var types: String = "songs,albums,artists,playlists"
    @Option(name: .long, help: "Maximum results per type") var limit: Int = 25
    @Option(name: .long, help: "Results offset") var offset: Int = 0
    @Flag(name: .long, help: "Pretty-print JSON") var pretty = false
    @Flag(name: .long, help: "Suppress non-JSON output") var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        let services = ServiceContainer.live()
        let typeList = types.split(separator: ",").map(String.init)
        try await SearchAllHandler.handle(services: services, options: options, query: query, types: typeList, limit: limit, offset: offset)
    }
    public init() {}
}
