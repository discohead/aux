import ArgumentParser

public struct LibraryMusicVideosCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "music-videos",
        abstract: "List music videos in your library"
    )

    @Option(name: .long, help: "Maximum results") var limit: Int = 25
    @Option(name: .long, help: "Results offset") var offset: Int = 0
    @Flag(name: .long, help: "Pretty-print JSON") var pretty = false
    @Flag(name: .long, help: "Suppress non-JSON output") var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        do {
            let services = ServiceContainer.live()
            try await LibraryMusicVideosHandler.handle(
                services: services, options: options,
                limit: limit, offset: offset
            )
        } catch {
            CommandErrorHandler.handle(error, options: options)
        }
    }
    public init() {}
}
