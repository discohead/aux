import ArgumentParser

public struct LibraryRenamePlaylistCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "rename-playlist",
        abstract: "Rename a playlist"
    )

    @Argument(help: "Current playlist name") var name: String
    @Argument(help: "New playlist name") var newName: String
    @Flag(name: .long, help: "Pretty-print JSON") var pretty = false
    @Flag(name: .long, help: "Suppress non-JSON output") var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        do {
            let services = ServiceContainer.live()
            try await LibraryRenamePlaylistHandler.handle(
                services: services, options: options,
                name: name, newName: newName
            )
        } catch {
            CommandErrorHandler.handle(error, options: options)
        }
    }
    public init() {}
}
