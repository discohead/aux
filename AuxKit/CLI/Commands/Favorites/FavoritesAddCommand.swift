import ArgumentParser

public struct FavoritesAddCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "add",
        abstract: "Add an item to favorites"
    )

    @Option(name: .long, help: "Item type (songs, albums, playlists, artists, music-videos, stations)")
    var type: String

    @Argument(help: "Item ID")
    var id: String

    @Flag(name: .long, help: "Pretty-print JSON output")
    var pretty = false

    @Flag(name: .long, help: "Suppress non-JSON output")
    var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        do {
            let services = ServiceContainer.live()
            try await FavoritesAddHandler.handle(services: services, options: options, type: type, id: id)
        } catch {
            CommandErrorHandler.handle(error, options: options)
        }
    }
    public init() {}
}
