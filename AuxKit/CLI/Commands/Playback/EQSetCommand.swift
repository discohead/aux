//
//  EQSetCommand.swift
//  auxCLI
//
//  Created by Jared McFarland on 3/16/26.
//

import ArgumentParser

public struct EQSetCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "eq-set",
        abstract: "Set the EQ preset"
    )

    @Option(name: .long, help: "Name of the EQ preset to set")
    var preset: String

    @Flag(name: .long, help: "Pretty-print JSON output")
    var pretty = false

    @Flag(name: .long, help: "Suppress non-JSON output")
    var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        do {
            let services = ServiceContainer.live()
            try await EQSetHandler.handle(services: services, options: options, preset: preset)
        } catch {
            CommandErrorHandler.handle(error, options: options)
        }
    }
    public init() {}
}
