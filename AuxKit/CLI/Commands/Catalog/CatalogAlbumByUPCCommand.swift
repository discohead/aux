//
//  CatalogAlbumByUPCCommand.swift
//  auxCLI
//
//  Created by Jared McFarland on 3/16/26.
//

import ArgumentParser

public struct CatalogAlbumByUPCCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "album-by-upc",
        abstract: "Get albums by UPC code"
    )

    @Argument(help: "UPC code")
    var upc: String

    @Flag(name: .long, help: "Pretty-print JSON output")
    var pretty = false

    @Flag(name: .long, help: "Suppress non-JSON output")
    var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        let services = ServiceContainer.live() // placeholder until live services exist
        try await CatalogAlbumByUPCHandler.handle(services: services, options: options, upc: upc)
    }
    public init() {}
}
