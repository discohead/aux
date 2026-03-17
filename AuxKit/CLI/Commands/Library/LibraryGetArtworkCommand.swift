import ArgumentParser

public struct LibraryGetArtworkCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "get-artwork",
        abstract: "Get artwork for a track"
    )

    @Argument(help: "Track database ID") var trackId: Int
    @Option(name: .long, help: "Artwork index (1-based)") var index: Int = 1
    @Flag(name: .long, help: "Pretty-print JSON") var pretty = false
    @Flag(name: .long, help: "Suppress non-JSON output") var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        do {
            let services = ServiceContainer.live()
            try await LibraryGetArtworkHandler.handle(
                services: services, options: options,
                trackId: trackId, index: index
            )
        } catch {
            CommandErrorHandler.handle(error, options: options)
        }
    }
    public init() {}
}
