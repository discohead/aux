import ArgumentParser

public struct LibraryReorderTracksCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "reorder-tracks",
        abstract: "Reorder tracks in a playlist"
    )

    @Argument(help: "Playlist name") var playlistName: String
    @Option(name: .long, help: "Track database IDs in desired order (comma-separated)") var trackIds: String
    @Flag(name: .long, help: "Pretty-print JSON") var pretty = false
    @Flag(name: .long, help: "Suppress non-JSON output") var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        do {
            let services = ServiceContainer.live()
            let ids = trackIds.split(separator: ",").compactMap { Int($0) }
            try await LibraryReorderTracksHandler.handle(
                services: services, options: options,
                playlistName: playlistName, trackIds: ids
            )
        } catch {
            CommandErrorHandler.handle(error, options: options)
        }
    }
    public init() {}
}
