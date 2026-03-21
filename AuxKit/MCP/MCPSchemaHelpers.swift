import Foundation
import MCP

/// Helpers for building JSON Schema Value objects for MCP tool inputSchemas.
public enum MCPSchema {
    public static func object(properties: [String: Value], required: [String] = []) -> Value {
        var schema: [String: Value] = [
            "type": .string("object"),
            "properties": .object(properties),
        ]
        if !required.isEmpty {
            schema["required"] = .array(required.map { .string($0) })
        }
        return .object(schema)
    }

    public static func string(_ description: String) -> Value {
        .object(["type": .string("string"), "description": .string(description)])
    }

    public static func stringEnum(_ description: String, values: [String]) -> Value {
        .object([
            "type": .string("string"),
            "description": .string(description),
            "enum": .array(values.map { .string($0) }),
        ])
    }

    public static func integer(_ description: String, default defaultValue: Int? = nil) -> Value {
        var prop: [String: Value] = [
            "type": .string("integer"), "description": .string(description),
        ]
        if let d = defaultValue { prop["default"] = .int(d) }
        return .object(prop)
    }

    public static func number(_ description: String) -> Value {
        .object(["type": .string("number"), "description": .string(description)])
    }

    public static func boolean(_ description: String, default defaultValue: Bool? = nil) -> Value {
        var prop: [String: Value] = [
            "type": .string("boolean"), "description": .string(description),
        ]
        if let d = defaultValue { prop["default"] = .bool(d) }
        return .object(prop)
    }

    public static func stringArray(_ description: String) -> Value {
        .object([
            "type": .string("array"),
            "description": .string(description),
            "items": .object(["type": .string("string")]),
        ])
    }

    public static func intArray(_ description: String) -> Value {
        .object([
            "type": .string("array"),
            "description": .string(description),
            "items": .object(["type": .string("integer")]),
        ])
    }

    public static func stringMap(_ description: String) -> Value {
        .object([
            "type": .string("object"),
            "description": .string(description),
            "additionalProperties": .object(["type": .string("string")]),
        ])
    }
}
