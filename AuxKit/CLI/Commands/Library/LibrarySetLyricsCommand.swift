import ArgumentParser

public struct LibrarySetLyricsCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "set-lyrics",
        abstract: "Set lyrics for a track"
    )

    @Argument(help: "Track database ID") var trackId: Int
    @Argument(help: "Lyrics text") var text: String
    @Flag(name: .long, help: "Pretty-print JSON") var pretty = false
    @Flag(name: .long, help: "Suppress non-JSON output") var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        do {
            let services = ServiceContainer.live()
            try await LibrarySetLyricsHandler.handle(
                services: services, options: options,
                trackId: trackId, text: text
            )
        } catch {
            CommandErrorHandler.handle(error, options: options)
        }
    }
    public init() {}
}
