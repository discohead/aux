import ArgumentParser

public struct LibrarySetTagsCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "set-tags",
        abstract: "Set metadata tags for a track"
    )

    @Argument(help: "Track database ID") var trackId: Int
    @Option(name: .long, help: "Fields to set as key=value pairs (comma-separated)") var fields: String
    @Flag(name: .long, help: "Pretty-print JSON") var pretty = false
    @Flag(name: .long, help: "Suppress non-JSON output") var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        let services = ServiceContainer.live()
        let fieldDict = parseFields(fields)
        try await LibrarySetTagsHandler.handle(
            services: services, options: options,
            trackId: trackId, fields: fieldDict
        )
    }

    private func parseFields(_ raw: String) -> [String: String] {
        var result: [String: String] = [:]
        for pair in raw.split(separator: ",") {
            let parts = pair.split(separator: "=", maxSplits: 1)
            if parts.count == 2 {
                result[String(parts[0])] = String(parts[1])
            }
        }
        return result
    }
    public init() {}
}
