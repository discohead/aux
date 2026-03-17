import ArgumentParser

public struct RecentlyPlayedTracksCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "tracks",
        abstract: "Get recently played tracks"
    )

    @Option(name: .long, help: "Maximum number of tracks") var limit: Int = 25
    @Flag(name: .long, help: "Pretty-print JSON") var pretty = false
    @Flag(name: .long, help: "Suppress non-JSON output") var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        do {
            let services = ServiceContainer.live()
            try await RecentlyPlayedTracksHandler.handle(services: services, options: options, limit: limit)
        } catch {
            CommandErrorHandler.handle(error, options: options)
        }
    }
    public init() {}
}
