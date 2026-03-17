import ArgumentParser

public struct RecommendationsListCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "list",
        abstract: "Get personalized music recommendations"
    )

    @Option(name: .long, help: "Maximum number of recommendation groups") var limit: Int = 10
    @Flag(name: .long, help: "Pretty-print JSON") var pretty = false
    @Flag(name: .long, help: "Suppress non-JSON output") var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        let services = ServiceContainer.live()
        try await RecommendationsHandler.handle(services: services, options: options, limit: limit)
    }
    public init() {}
}
