import ArgumentParser

public struct LibraryGetPlayStatsCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "get-play-stats",
        abstract: "Get play statistics for a track"
    )

    @Argument(help: "Track database ID") var trackId: Int
    @Flag(name: .long, help: "Pretty-print JSON") var pretty = false
    @Flag(name: .long, help: "Suppress non-JSON output") var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        let services = ServiceContainer.live()
        try await LibraryGetPlayStatsHandler.handle(
            services: services, options: options, trackId: trackId
        )
    }
    public init() {}
}
