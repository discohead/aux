import ArgumentParser

public struct LibrarySearchCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "search",
        abstract: "Search your library"
    )

    @Argument(help: "Search query") var query: String
    @Option(name: .long, help: "Resource types to search (comma-separated)") var types: String = ""
    @Option(name: .long, help: "Maximum results") var limit: Int = 25
    @Flag(name: .long, help: "Pretty-print JSON") var pretty = false
    @Flag(name: .long, help: "Suppress non-JSON output") var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        do {
            let services = ServiceContainer.live()
            let typeArray = types.isEmpty ? [] : types.split(separator: ",").map(String.init)
            try await LibrarySearchHandler.handle(
                services: services, options: options,
                query: query, types: typeArray, limit: limit
            )
        } catch {
            CommandErrorHandler.handle(error, options: options)
        }
    }
    public init() {}
}
