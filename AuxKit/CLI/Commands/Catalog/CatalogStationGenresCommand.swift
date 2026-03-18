//
//  CatalogStationGenresCommand.swift
//  auxCLI
//
//  Created by Jared McFarland on 3/17/26.
//

import ArgumentParser

public struct CatalogStationGenresCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "station-genres",
        abstract: "Get available station genres"
    )

    @Option(name: .long, help: "Storefront ID (e.g. us, gb)")
    var storefront: String

    @Flag(name: .long, help: "Pretty-print JSON output")
    var pretty = false

    @Flag(name: .long, help: "Suppress non-JSON output")
    var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        do {
            let services = ServiceContainer.live()
            try await CatalogStationGenresHandler.handle(
                services: services, options: options, storefront: storefront
            )
        } catch {
            CommandErrorHandler.handle(error, options: options)
        }
    }
    public init() {}
}
