//
//  MCPServeCommand.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/21/26.
//

import ArgumentParser
import Foundation
import MCP

public struct MCPServeCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "serve",
        abstract: "Start the MCP server (stdio transport)"
    )

    public func run() async throws {
        let services = ServiceContainer.live()
        let server = AuxMCPServer(services: services)
        let transport = StdioTransport()
        try await server.start(transport: transport)
        await server.waitUntilCompleted()
    }

    public init() {}
}
