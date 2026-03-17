//
//  PlayCommand.swift
//  auxCLI
//
//  Created by Jared McFarland on 3/16/26.
//

import ArgumentParser

public struct PlayCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "play",
        abstract: "Start or resume playback"
    )

    @Option(name: .long, help: "Track database ID to play")
    var trackId: Int?

    @Flag(name: .long, help: "Pretty-print JSON output")
    var pretty = false

    @Flag(name: .long, help: "Suppress non-JSON output")
    var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        let services = ServiceContainer.live() // placeholder until live services exist
        try await PlayHandler.handle(services: services, options: options, trackId: trackId)
    }
    public init() {}
}
