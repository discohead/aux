import ArgumentParser

public struct LibraryAddToPlaylistCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "add-to-playlist",
        abstract: "Add tracks to an existing playlist"
    )

    @Argument(help: "Playlist ID") var playlistId: String
    @Option(name: .long, help: "Track IDs to add (comma-separated)") var trackIds: String
    @Flag(name: .long, help: "Pretty-print JSON") var pretty = false
    @Flag(name: .long, help: "Suppress non-JSON output") var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        let services = ServiceContainer.live()
        let ids = trackIds.split(separator: ",").map(String.init)
        try await LibraryAddToPlaylistHandler.handle(
            services: services, options: options,
            playlistId: playlistId, trackIds: ids
        )
    }
    public init() {}
}
