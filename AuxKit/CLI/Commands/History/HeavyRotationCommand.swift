import ArgumentParser

public struct HeavyRotationCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "heavy-rotation",
        abstract: "Get heavy rotation content"
    )

    @Option(name: .long, help: "Maximum number of items") var limit: Int = 25
    @Flag(name: .long, help: "Pretty-print JSON output") var pretty = false
    @Flag(name: .long, help: "Suppress non-JSON output") var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        do {
            let services = ServiceContainer.live()
            try await HeavyRotationHandler.handle(services: services, options: options, limit: limit)
        } catch {
            CommandErrorHandler.handle(error, options: options)
        }
    }
    public init() {}
}
