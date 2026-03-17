//
//  PreviousCommand.swift
//  auxCLI
//
//  Created by Jared McFarland on 3/16/26.
//

import ArgumentParser

public struct PreviousCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "previous",
        abstract: "Go to the previous track"
    )

    @Flag(name: .long, help: "Pretty-print JSON output")
    var pretty = false

    @Flag(name: .long, help: "Suppress non-JSON output")
    var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        do {
            let services = ServiceContainer.live()
            try await PreviousHandler.handle(services: services, options: options)
        } catch {
            CommandErrorHandler.handle(error, options: options)
        }
    }
    public init() {}
}
