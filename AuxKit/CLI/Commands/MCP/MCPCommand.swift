//
//  MCPCommand.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/21/26.
//

import ArgumentParser

public struct MCPCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "mcp",
        abstract: "Model Context Protocol server",
        subcommands: [MCPServeCommand.self]
    )
    public init() {}
}
