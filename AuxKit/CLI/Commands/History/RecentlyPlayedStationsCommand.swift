import ArgumentParser

public struct RecentlyPlayedStationsCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "recently-played-stations",
        abstract: "Get recently played stations"
    )

    @Option(name: .long, help: "Maximum number of stations") var limit: Int = 25
    @Flag(name: .long, help: "Pretty-print JSON output") var pretty = false
    @Flag(name: .long, help: "Suppress non-JSON output") var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        do {
            let services = ServiceContainer.live()
            try await RecentlyPlayedStationsHandler.handle(services: services, options: options, limit: limit)
        } catch {
            CommandErrorHandler.handle(error, options: options)
        }
    }
    public init() {}
}
