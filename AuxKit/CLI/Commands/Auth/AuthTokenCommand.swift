//
//  AuthTokenCommand.swift
//  auxCLI
//
//  Created by Jared McFarland on 3/16/26.
//

import ArgumentParser

public struct AuthTokenCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "token",
        abstract: "Retrieve Apple Music tokens"
    )

    @Option(name: .long, help: "Token type to retrieve (developer or user)")
    var type: String = "developer"

    @Flag(name: .long, help: "Pretty-print JSON output")
    var pretty = false

    @Flag(name: .long, help: "Suppress non-JSON output")
    var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        do {
            let services = ServiceContainer.live() // placeholder until live services exist
            try await AuthTokenHandler.handle(services: services, options: options, type: type)
        } catch {
            CommandErrorHandler.handle(error, options: options)
        }
    }
    public init() {}
}
