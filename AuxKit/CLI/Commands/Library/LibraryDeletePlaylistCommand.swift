import ArgumentParser

public struct LibraryDeletePlaylistCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "delete-playlist",
        abstract: "Delete a playlist"
    )

    @Argument(help: "Playlist name") var name: String
    @Flag(name: .long, help: "Pretty-print JSON") var pretty = false
    @Flag(name: .long, help: "Suppress non-JSON output") var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        let services = ServiceContainer.live()
        try await LibraryDeletePlaylistHandler.handle(
            services: services, options: options, name: name
        )
    }
    public init() {}
}
