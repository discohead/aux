import ArgumentParser

public struct LibraryDeleteCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "delete",
        abstract: "Delete tracks from the library"
    )

    @Option(name: .long, help: "Track database IDs (comma-separated)") var trackIds: String
    @Flag(name: .long, help: "Pretty-print JSON") var pretty = false
    @Flag(name: .long, help: "Suppress non-JSON output") var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        do {
            let services = ServiceContainer.live()
            let ids = trackIds.split(separator: ",").compactMap { Int($0) }
            try await LibraryDeleteHandler.handle(
                services: services, options: options, trackIds: ids
            )
        } catch {
            CommandErrorHandler.handle(error, options: options)
        }
    }
    public init() {}
}
