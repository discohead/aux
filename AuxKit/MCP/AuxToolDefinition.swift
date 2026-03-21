import Foundation
import MCP

/// A declarative definition of an MCP tool backed by an AuxKit handler.
public struct AuxToolDefinition: Sendable {
    public let name: String
    public let description: String
    public let inputSchema: Value
    public let annotations: Tool.Annotations?
    public let execute: @Sendable (ServiceContainer, [String: Value]?) async throws -> String

    public init(
        name: String,
        description: String,
        inputSchema: Value,
        annotations: Tool.Annotations? = nil,
        execute: @escaping @Sendable (ServiceContainer, [String: Value]?) async throws -> String
    ) {
        self.name = name
        self.description = description
        self.inputSchema = inputSchema
        self.annotations = annotations
        self.execute = execute
    }

    /// Converts to the MCP SDK Tool type for registration.
    public func toMCPTool() -> Tool {
        Tool(
            name: name,
            description: description,
            inputSchema: inputSchema,
            annotations: annotations ?? nil
        )
    }
}
