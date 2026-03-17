import ArgumentParser

public struct LibraryImportCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "import",
        abstract: "Import audio files into the library"
    )

    @Option(name: .long, help: "File paths (comma-separated)") var paths: String
    @Option(name: .long, help: "Target playlist name") var toPlaylist: String?
    @Flag(name: .long, help: "Pretty-print JSON") var pretty = false
    @Flag(name: .long, help: "Suppress non-JSON output") var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        let services = ServiceContainer.live()
        let pathArray = paths.split(separator: ",").map(String.init)
        try await LibraryImportHandler.handle(
            services: services, options: options,
            paths: pathArray, toPlaylist: toPlaylist
        )
    }
    public init() {}
}
