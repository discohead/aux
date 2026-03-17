import ArgumentParser

public struct LibraryGetLyricsCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "get-lyrics",
        abstract: "Get lyrics for a track"
    )

    @Argument(help: "Track database ID") var trackId: Int
    @Flag(name: .long, help: "Pretty-print JSON") var pretty = false
    @Flag(name: .long, help: "Suppress non-JSON output") var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        do {
            let services = ServiceContainer.live()
            try await LibraryGetLyricsHandler.handle(
                services: services, options: options, trackId: trackId
            )
        } catch {
            CommandErrorHandler.handle(error, options: options)
        }
    }
    public init() {}
}
