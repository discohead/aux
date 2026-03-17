import ArgumentParser

public struct LibraryPlaylistsCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "playlists",
        abstract: "List playlists in your library"
    )

    @Option(name: .long, help: "Maximum results") var limit: Int = 25
    @Option(name: .long, help: "Results offset") var offset: Int = 0
    @Option(name: .long, help: "Sort order") var sort: String?
    @Flag(name: .long, help: "Pretty-print JSON") var pretty = false
    @Flag(name: .long, help: "Suppress non-JSON output") var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        do {
            let services = ServiceContainer.live()
            try await LibraryPlaylistsHandler.handle(
                services: services, options: options,
                limit: limit, offset: offset, sort: sort
            )
        } catch {
            CommandErrorHandler.handle(error, options: options)
        }
    }
    public init() {}
}
