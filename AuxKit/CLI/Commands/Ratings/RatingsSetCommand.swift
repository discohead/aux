//
//  RatingsSetCommand.swift
//  auxCLI
//
//  Created by Jared McFarland on 3/16/26.
//

import ArgumentParser

public struct RatingsSetCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "set",
        abstract: "Set a rating for an item"
    )

    @Option(name: .long, help: "Item type (songs, albums, playlists, music-videos)")
    var type: String

    @Argument(help: "Item ID")
    var id: String

    @Option(name: .long, help: "Rating value (1 = dislike, 2-5 = like/love)")
    var rating: Int

    @Flag(name: .long, help: "Pretty-print JSON output")
    var pretty = false

    @Flag(name: .long, help: "Suppress non-JSON output")
    var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        let services = ServiceContainer.live() // placeholder until live services exist
        try await RatingsSetHandler.handle(services: services, options: options, type: type, id: id, rating: rating)
    }
    public init() {}
}
