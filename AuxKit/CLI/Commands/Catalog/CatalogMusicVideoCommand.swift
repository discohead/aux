//
//  CatalogMusicVideoCommand.swift
//  auxCLI
//
//  Created by Jared McFarland on 3/16/26.
//

import ArgumentParser

public struct CatalogMusicVideoCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "music-video",
        abstract: "Get a music video by its catalog ID"
    )

    @Argument(help: "Apple Music catalog ID")
    var id: String

    @Flag(name: .long, help: "Pretty-print JSON output")
    var pretty = false

    @Flag(name: .long, help: "Suppress non-JSON output")
    var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        do {
            let services = ServiceContainer.live() // placeholder until live services exist
            try await CatalogMusicVideoHandler.handle(services: services, options: options, id: id)
        } catch {
            CommandErrorHandler.handle(error, options: options)
        }
    }
    public init() {}
}
