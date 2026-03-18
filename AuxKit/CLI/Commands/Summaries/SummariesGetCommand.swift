//
//  SummariesGetCommand.swift
//  auxCLI
//
//  Created by Jared McFarland on 3/17/26.
//

import ArgumentParser

public struct SummariesGetCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "get",
        abstract: "Get music summaries for a given year"
    )

    @Option(name: .long, help: "Year to retrieve summaries for (default: latest)")
    var year: String = "latest"

    @Option(name: .long, help: "Views to include: top-artists, top-albums, top-songs, or all (default: all)")
    var view: [String] = ["all"]

    @Flag(name: .long, help: "Pretty-print JSON output")
    var pretty = false

    @Flag(name: .long, help: "Suppress non-JSON output")
    var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        do {
            let services = ServiceContainer.live()
            try await SummariesGetHandler.handle(
                services: services, options: options, year: year, views: view
            )
        } catch {
            CommandErrorHandler.handle(error, options: options)
        }
    }
    public init() {}
}
