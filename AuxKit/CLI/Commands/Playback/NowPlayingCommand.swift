//
//  NowPlayingCommand.swift
//  auxCLI
//
//  Created by Jared McFarland on 3/16/26.
//

import ArgumentParser

public struct NowPlayingCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "now-playing",
        abstract: "Get the currently playing track"
    )

    @Flag(name: .long, help: "Pretty-print JSON output")
    var pretty = false

    @Flag(name: .long, help: "Suppress non-JSON output")
    var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        let services = ServiceContainer.live()
        try await NowPlayingHandler.handle(services: services, options: options)
    }
    public init() {}
}
