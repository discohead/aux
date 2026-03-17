import ArgumentParser

public struct LibraryAddCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "add",
        abstract: "Add catalog items to your library"
    )

    @Option(name: .long, help: "Catalog IDs to add (comma-separated)") var ids: String
    @Option(name: .long, help: "Resource type (songs, albums, playlists)") var type: String
    @Flag(name: .long, help: "Pretty-print JSON") var pretty = false
    @Flag(name: .long, help: "Suppress non-JSON output") var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        do {
            let services = ServiceContainer.live()
            let idArray = ids.split(separator: ",").map(String.init)
            try await LibraryAddHandler.handle(
                services: services, options: options,
                ids: idArray, type: type
            )
        } catch {
            CommandErrorHandler.handle(error, options: options)
        }
    }
    public init() {}
}
