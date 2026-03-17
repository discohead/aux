import ArgumentParser

public struct LibraryAlbumsCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "albums",
        abstract: "List albums in your library"
    )

    @Option(name: .long, help: "Maximum results") var limit: Int = 25
    @Option(name: .long, help: "Results offset") var offset: Int = 0
    @Option(name: .long, help: "Sort order") var sort: String?
    @Option(name: .long, help: "Filter by title") var title: String?
    @Option(name: .long, help: "Filter by artist") var artist: String?
    @Flag(name: .long, help: "Pretty-print JSON") var pretty = false
    @Flag(name: .long, help: "Suppress non-JSON output") var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        do {
            let services = ServiceContainer.live()
            try await LibraryAlbumsHandler.handle(
                services: services, options: options,
                limit: limit, offset: offset, sort: sort,
                title: title, artist: artist
            )
        } catch {
            CommandErrorHandler.handle(error, options: options)
        }
    }
    public init() {}
}
