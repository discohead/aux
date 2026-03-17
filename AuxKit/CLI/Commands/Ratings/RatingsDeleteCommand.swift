//
//  RatingsDeleteCommand.swift
//  auxCLI
//
//  Created by Jared McFarland on 3/16/26.
//

import ArgumentParser

public struct RatingsDeleteCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "delete",
        abstract: "Delete a rating for an item"
    )

    @Option(name: .long, help: "Item type (songs, albums, playlists, music-videos)")
    var type: String

    @Argument(help: "Item ID")
    var id: String

    @Flag(name: .long, help: "Pretty-print JSON output")
    var pretty = false

    @Flag(name: .long, help: "Suppress non-JSON output")
    var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        let services = ServiceContainer.live() // placeholder until live services exist
        try await RatingsDeleteHandler.handle(services: services, options: options, type: type, id: id)
    }
    public init() {}
}
