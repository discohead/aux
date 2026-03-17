//
//  AirPlayCurrentCommand.swift
//  auxCLI
//
//  Created by Jared McFarland on 3/16/26.
//

import ArgumentParser

public struct AirPlayCurrentCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "airplay-current",
        abstract: "Get the current AirPlay device"
    )

    @Flag(name: .long, help: "Pretty-print JSON output")
    var pretty = false

    @Flag(name: .long, help: "Suppress non-JSON output")
    var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        let services = ServiceContainer.live()
        try await AirPlayCurrentHandler.handle(services: services, options: options)
    }
    public init() {}
}
