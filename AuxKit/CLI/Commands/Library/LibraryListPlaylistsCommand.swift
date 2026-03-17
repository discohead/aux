import ArgumentParser

public struct LibraryListPlaylistsCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "list-playlists",
        abstract: "List all playlists via AppleScript"
    )

    @Flag(name: .long, help: "Pretty-print JSON") var pretty = false
    @Flag(name: .long, help: "Suppress non-JSON output") var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        let services = ServiceContainer.live()
        try await LibraryListPlaylistsHandler.handle(
            services: services, options: options
        )
    }
    public init() {}
}
