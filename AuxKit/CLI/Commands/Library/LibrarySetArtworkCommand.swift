import ArgumentParser

public struct LibrarySetArtworkCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "set-artwork",
        abstract: "Set artwork for a track"
    )

    @Argument(help: "Track database ID") var trackId: Int
    @Argument(help: "Path to image file") var imagePath: String
    @Flag(name: .long, help: "Pretty-print JSON") var pretty = false
    @Flag(name: .long, help: "Suppress non-JSON output") var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        do {
            let services = ServiceContainer.live()
            try await LibrarySetArtworkHandler.handle(
                services: services, options: options,
                trackId: trackId, imagePath: imagePath
            )
        } catch {
            CommandErrorHandler.handle(error, options: options)
        }
    }
    public init() {}
}
