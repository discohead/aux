//
//  AirPlaySelectCommand.swift
//  auxCLI
//
//  Created by Jared McFarland on 3/16/26.
//

import ArgumentParser

public struct AirPlaySelectCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "airplay-select",
        abstract: "Select an AirPlay device by name"
    )

    @Option(name: .long, help: "Name of the AirPlay device to select")
    var name: String

    @Flag(name: .long, help: "Pretty-print JSON output")
    var pretty = false

    @Flag(name: .long, help: "Suppress non-JSON output")
    var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        let services = ServiceContainer.live()
        try await AirPlaySelectHandler.handle(services: services, options: options, name: name)
    }
    public init() {}
}
