import ArgumentParser

public struct LibraryResetPlayStatsCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "reset-play-stats",
        abstract: "Reset play statistics for tracks"
    )

    @Option(name: .long, help: "Track database IDs (comma-separated)") var trackIds: String
    @Flag(name: .long, help: "Pretty-print JSON") var pretty = false
    @Flag(name: .long, help: "Suppress non-JSON output") var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        do {
            let services = ServiceContainer.live()
            let ids = trackIds.split(separator: ",").compactMap { Int($0) }
            try await LibraryResetPlayStatsHandler.handle(
                services: services, options: options, trackIds: ids
            )
        } catch {
            CommandErrorHandler.handle(error, options: options)
        }
    }
    public init() {}
}
