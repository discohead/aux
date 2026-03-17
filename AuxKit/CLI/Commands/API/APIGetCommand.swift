//
//  APIGetCommand.swift
//  auxCLI
//
//  Created by Jared McFarland on 3/16/26.
//

import ArgumentParser

public struct APIGetCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "get",
        abstract: "Make a GET request to the Apple Music API"
    )

    @Argument(help: "API path (e.g., /v1/catalog/us/songs/123)")
    var path: String

    @Option(name: .long, help: "Query parameter (key=value), repeatable")
    var query: [String] = []

    @Flag(name: .long, help: "Pretty-print JSON output")
    var pretty = false

    @Flag(name: .long, help: "Suppress non-JSON output")
    var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        let services = ServiceContainer.live() // placeholder until live services exist
        let params = query.isEmpty ? nil : Dictionary(uniqueKeysWithValues: query.compactMap { kv -> (String, String)? in
            let parts = kv.split(separator: "=", maxSplits: 1)
            guard parts.count == 2 else { return nil }
            return (String(parts[0]), String(parts[1]))
        })
        try await APIGetHandler.handle(services: services, options: options, path: path, queryParams: params)
    }
    public init() {}
}
