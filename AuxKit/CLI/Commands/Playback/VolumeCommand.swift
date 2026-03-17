//
//  VolumeCommand.swift
//  auxCLI
//
//  Created by Jared McFarland on 3/16/26.
//

import ArgumentParser

public struct VolumeCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "volume",
        abstract: "Set the player volume (0.0 to 100.0)"
    )

    @Option(name: .long, help: "Volume level (0.0 to 100.0)")
    var level: Double

    @Flag(name: .long, help: "Pretty-print JSON output")
    var pretty = false

    @Flag(name: .long, help: "Suppress non-JSON output")
    var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        let services = ServiceContainer.live()
        try await VolumeHandler.handle(services: services, options: options, volume: level)
    }
    public init() {}
}
