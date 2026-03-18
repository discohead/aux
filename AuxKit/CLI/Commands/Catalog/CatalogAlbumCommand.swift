//
//  CatalogAlbumCommand.swift
//  auxCLI
//
//  Created by Jared McFarland on 3/16/26.
//

import ArgumentParser

public struct CatalogAlbumCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "album",
        abstract: "Get an album by its catalog ID"
    )

    @Argument(help: "Apple Music catalog ID")
    var id: String

    @Option(name: .long, help: "Relationships to include (e.g. artists, tracks)")
    var include: [String] = []

    @Flag(name: .long, help: "Pretty-print JSON output")
    var pretty = false

    @Flag(name: .long, help: "Suppress non-JSON output")
    var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        do {
            let services = ServiceContainer.live() // placeholder until live services exist
            try await CatalogAlbumHandler.handle(services: services, options: options, id: id, include: include.isEmpty ? nil : include)
        } catch {
            CommandErrorHandler.handle(error, options: options)
        }
    }
    public init() {}
}
