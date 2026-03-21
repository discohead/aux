//
//  ToolRegistryProtocol.swift
//  AuxKit
//

import Foundation
import MCP

/// Protocol for MCP tool registries, enabling dependency injection and testing.
public protocol ToolRegistryProtocol: Sendable {
    func allTools() -> [AuxToolDefinition]
    func tool(named: String) -> AuxToolDefinition?
    func mcpTools() -> [Tool]
}
