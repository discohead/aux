import ArgumentParser

public struct LibraryGetFileInfoCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "get-file-info",
        abstract: "Get file information for a track"
    )

    @Argument(help: "Track database ID") var trackId: Int
    @Flag(name: .long, help: "Pretty-print JSON") var pretty = false
    @Flag(name: .long, help: "Suppress non-JSON output") var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        do {
            let services = ServiceContainer.live()
            try await LibraryGetFileInfoHandler.handle(
                services: services, options: options, trackId: trackId
            )
        } catch {
            CommandErrorHandler.handle(error, options: options)
        }
    }
    public init() {}
}
