//
//  CatalogSongByISRCCommand.swift
//  auxCLI
//
//  Created by Jared McFarland on 3/16/26.
//

import ArgumentParser

public struct CatalogSongByISRCCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "song-by-isrc",
        abstract: "Get songs by ISRC code"
    )

    @Argument(help: "ISRC code")
    var isrc: String

    @Flag(name: .long, help: "Pretty-print JSON output")
    var pretty = false

    @Flag(name: .long, help: "Suppress non-JSON output")
    var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        do {
            let services = ServiceContainer.live() // placeholder until live services exist
            try await CatalogSongByISRCHandler.handle(services: services, options: options, isrc: isrc)
        } catch {
            CommandErrorHandler.handle(error, options: options)
        }
    }
    public init() {}
}
