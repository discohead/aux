import ArgumentParser

public struct RecentlyPlayedContainersCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "containers",
        abstract: "Get recently played containers (albums, playlists, stations)"
    )

    @Option(name: .long, help: "Maximum number of containers") var limit: Int = 10
    @Flag(name: .long, help: "Pretty-print JSON") var pretty = false
    @Flag(name: .long, help: "Suppress non-JSON output") var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        let services = ServiceContainer.live()
        try await RecentlyPlayedContainersHandler.handle(services: services, options: options, limit: limit)
    }
    public init() {}
}
