//
//  APIPutCommand.swift
//  auxCLI
//
//  Created by Jared McFarland on 3/16/26.
//

import ArgumentParser

public struct APIPutCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "put",
        abstract: "Make a PUT request to the Apple Music API"
    )

    @Argument(help: "API path (e.g., /v1/me/ratings/songs/123)")
    var path: String

    @Option(name: .long, help: "JSON request body")
    var body: String?

    @Flag(name: .long, help: "Pretty-print JSON output")
    var pretty = false

    @Flag(name: .long, help: "Suppress non-JSON output")
    var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        do {
            let services = ServiceContainer.live() // placeholder until live services exist
            try await APIPutHandler.handle(services: services, options: options, path: path, body: body)
        } catch {
            CommandErrorHandler.handle(error, options: options)
        }
    }
    public init() {}
}
