//
//  NextCommand.swift
//  auxCLI
//
//  Created by Jared McFarland on 3/16/26.
//

import ArgumentParser

public struct NextCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "next",
        abstract: "Skip to the next track"
    )

    @Flag(name: .long, help: "Pretty-print JSON output")
    var pretty = false

    @Flag(name: .long, help: "Suppress non-JSON output")
    var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        do {
            let services = ServiceContainer.live()
            try await NextHandler.handle(services: services, options: options)
        } catch {
            CommandErrorHandler.handle(error, options: options)
        }
    }
    public init() {}
}
