import ArgumentParser

public struct LibraryRemoveFromPlaylistCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "remove-from-playlist",
        abstract: "Remove tracks from a playlist"
    )

    @Argument(help: "Playlist name") var playlistName: String
    @Option(name: .long, help: "Track database IDs (comma-separated)") var trackIds: String
    @Flag(name: .long, help: "Pretty-print JSON") var pretty = false
    @Flag(name: .long, help: "Suppress non-JSON output") var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        let services = ServiceContainer.live()
        let ids = trackIds.split(separator: ",").compactMap { Int($0) }
        try await LibraryRemoveFromPlaylistHandler.handle(
            services: services, options: options,
            playlistName: playlistName, trackIds: ids
        )
    }
    public init() {}
}
