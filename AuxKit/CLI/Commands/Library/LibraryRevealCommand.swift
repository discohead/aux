import ArgumentParser

public struct LibraryRevealCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "reveal",
        abstract: "Reveal a track's file in Finder"
    )

    @Argument(help: "Track database ID") var trackId: Int
    @Flag(name: .long, help: "Pretty-print JSON") var pretty = false
    @Flag(name: .long, help: "Suppress non-JSON output") var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        let services = ServiceContainer.live()
        try await LibraryRevealHandler.handle(
            services: services, options: options, trackId: trackId
        )
    }
    public init() {}
}
