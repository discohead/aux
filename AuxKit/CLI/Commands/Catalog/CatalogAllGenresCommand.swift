//
//  CatalogAllGenresCommand.swift
//  auxCLI
//
//  Created by Jared McFarland on 3/16/26.
//

import ArgumentParser

public struct CatalogAllGenresCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "all-genres",
        abstract: "Get all available genres"
    )

    @Flag(name: .long, help: "Pretty-print JSON output")
    var pretty = false

    @Flag(name: .long, help: "Suppress non-JSON output")
    var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        let services = ServiceContainer.live() // placeholder until live services exist
        try await CatalogAllGenresHandler.handle(services: services, options: options)
    }
    public init() {}
}
