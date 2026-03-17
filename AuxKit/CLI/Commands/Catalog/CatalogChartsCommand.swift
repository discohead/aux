//
//  CatalogChartsCommand.swift
//  auxCLI
//
//  Created by Jared McFarland on 3/16/26.
//

import ArgumentParser

public struct CatalogChartsCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "charts",
        abstract: "Get Apple Music charts"
    )

    @Option(name: .long, help: "Chart kinds (e.g. most-played, city-top)")
    var kinds: [String] = []

    @Option(name: .long, help: "Chart types (e.g. songs, albums, playlists)")
    var types: [String] = []

    @Option(name: .long, help: "Filter by genre ID")
    var genreId: String?

    @Option(name: .long, help: "Maximum number of results per chart")
    var limit: Int = 25

    @Flag(name: .long, help: "Pretty-print JSON output")
    var pretty = false

    @Flag(name: .long, help: "Suppress non-JSON output")
    var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        do {
            let services = ServiceContainer.live() // placeholder until live services exist
            try await CatalogChartsHandler.handle(
                services: services,
                options: options,
                kinds: kinds,
                types: types,
                genreId: genreId,
                limit: limit
            )
        } catch {
            CommandErrorHandler.handle(error, options: options)
        }
    }
    public init() {}
}
