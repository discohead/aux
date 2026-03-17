import ArgumentParser

public struct LibraryFindDuplicatesCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "find-duplicates",
        abstract: "Find duplicate tracks in a playlist"
    )

    @Argument(help: "Playlist name") var playlistName: String
    @Flag(name: .long, help: "Pretty-print JSON") var pretty = false
    @Flag(name: .long, help: "Suppress non-JSON output") var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        do {
            let services = ServiceContainer.live()
            try await LibraryFindDuplicatesHandler.handle(
                services: services, options: options,
                playlistName: playlistName
            )
        } catch {
            CommandErrorHandler.handle(error, options: options)
        }
    }
    public init() {}
}
