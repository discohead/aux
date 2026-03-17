import ArgumentParser

public struct LibraryArtistsCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "artists",
        abstract: "List artists in your library"
    )

    @Option(name: .long, help: "Maximum results") var limit: Int = 25
    @Option(name: .long, help: "Results offset") var offset: Int = 0
    @Option(name: .long, help: "Sort order") var sort: String?
    @Option(name: .long, help: "Filter by name") var filterName: String?
    @Flag(name: .long, help: "Pretty-print JSON") var pretty = false
    @Flag(name: .long, help: "Suppress non-JSON output") var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        let services = ServiceContainer.live()
        try await LibraryArtistsHandler.handle(
            services: services, options: options,
            limit: limit, offset: offset, sort: sort,
            filterName: filterName
        )
    }
    public init() {}
}
