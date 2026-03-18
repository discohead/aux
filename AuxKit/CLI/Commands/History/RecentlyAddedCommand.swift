import ArgumentParser

public struct RecentlyAddedCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "recently-added",
        abstract: "Get recently added resources"
    )

    @Option(name: .long, help: "Maximum number of items") var limit: Int = 25
    @Flag(name: .long, help: "Pretty-print JSON output") var pretty = false
    @Flag(name: .long, help: "Suppress non-JSON output") var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        do {
            let services = ServiceContainer.live()
            try await RecentlyAddedHandler.handle(services: services, options: options, limit: limit)
        } catch {
            CommandErrorHandler.handle(error, options: options)
        }
    }
    public init() {}
}
