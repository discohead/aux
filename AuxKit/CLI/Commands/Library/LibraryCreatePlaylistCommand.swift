import ArgumentParser

public struct LibraryCreatePlaylistCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "create-playlist",
        abstract: "Create a new playlist in your library"
    )

    @Argument(help: "Playlist name") var name: String
    @Option(name: .long, help: "Playlist description") var description: String?
    @Option(name: .long, help: "Track IDs to include (comma-separated)") var trackIds: String?
    @Flag(name: .long, help: "Pretty-print JSON") var pretty = false
    @Flag(name: .long, help: "Suppress non-JSON output") var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        let services = ServiceContainer.live()
        let ids = trackIds?.split(separator: ",").map(String.init) ?? []
        try await LibraryCreatePlaylistHandler.handle(
            services: services, options: options,
            name: name, description: description, trackIds: ids
        )
    }
    public init() {}
}
