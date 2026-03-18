//
//  CatalogStationsForGenreCommand.swift
//  auxCLI
//
//  Created by Jared McFarland on 3/17/26.
//

import ArgumentParser

public struct CatalogStationsForGenreCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "stations-for-genre",
        abstract: "Get stations for a specific genre"
    )

    @Option(name: .long, help: "Storefront ID (e.g. us, gb)")
    var storefront: String

    @Argument(help: "Station genre ID")
    var genreId: String

    @Option(name: .long, help: "Maximum number of results (default: 25)")
    var limit: Int = 25

    @Flag(name: .long, help: "Pretty-print JSON output")
    var pretty = false

    @Flag(name: .long, help: "Suppress non-JSON output")
    var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        do {
            let services = ServiceContainer.live()
            try await CatalogStationsForGenreHandler.handle(
                services: services, options: options, storefront: storefront, genreId: genreId, limit: limit
            )
        } catch {
            CommandErrorHandler.handle(error, options: options)
        }
    }
    public init() {}
}
