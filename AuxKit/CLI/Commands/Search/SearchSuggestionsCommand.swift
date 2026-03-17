import ArgumentParser

public struct SearchSuggestionsCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "suggestions",
        abstract: "Get search suggestions from the Apple Music catalog"
    )

    @Argument(help: "Search query") var query: String
    @Option(name: .long, help: "Maximum suggestions") var limit: Int = 10
    @Option(name: .long, help: "Resource types to suggest (comma-separated)") var types: String?
    @Flag(name: .long, help: "Pretty-print JSON") var pretty = false
    @Flag(name: .long, help: "Suppress non-JSON output") var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        do {
            let services = ServiceContainer.live()
            let typeList = types?.split(separator: ",").map(String.init)
            try await SearchSuggestionsHandler.handle(services: services, options: options, query: query, limit: limit, types: typeList)
        } catch {
            CommandErrorHandler.handle(error, options: options)
        }
    }
    public init() {}
}
