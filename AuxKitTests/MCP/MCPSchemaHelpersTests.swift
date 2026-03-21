//
//  MCPSchemaHelpersTests.swift
//  AuxKitTests
//

import Testing
import MCP
@testable import AuxKit

@Suite("MCPSchemaHelpers Tests")
struct MCPSchemaHelpersTests {

    @Test("object produces correct JSON Schema structure")
    func objectSchema() {
        let schema = MCPSchema.object(
            properties: ["query": MCPSchema.string("Search query")],
            required: ["query"]
        )
        guard case .object(let obj) = schema else {
            Issue.record("Expected object value")
            return
        }
        #expect(obj["type"] == .string("object"))
        guard case .object(let props) = obj["properties"] else {
            Issue.record("Expected properties object")
            return
        }
        #expect(props["query"] != nil)
        guard case .array(let req) = obj["required"] else {
            Issue.record("Expected required array")
            return
        }
        #expect(req == [.string("query")])
    }

    @Test("object omits required when empty")
    func objectOmitsEmptyRequired() {
        let schema = MCPSchema.object(properties: ["key": MCPSchema.string("desc")])
        guard case .object(let obj) = schema else {
            Issue.record("Expected object value")
            return
        }
        #expect(obj["required"] == nil)
    }

    @Test("string produces correct structure")
    func stringSchema() {
        let schema = MCPSchema.string("A description")
        guard case .object(let obj) = schema else {
            Issue.record("Expected object value")
            return
        }
        #expect(obj["type"] == .string("string"))
        #expect(obj["description"] == .string("A description"))
    }

    @Test("integer with default includes default key")
    func integerWithDefault() {
        let schema = MCPSchema.integer("Max results", default: 25)
        guard case .object(let obj) = schema else {
            Issue.record("Expected object value")
            return
        }
        #expect(obj["type"] == .string("integer"))
        #expect(obj["default"] == .int(25))
    }

    @Test("integer without default omits default key")
    func integerWithoutDefault() {
        let schema = MCPSchema.integer("Max results")
        guard case .object(let obj) = schema else {
            Issue.record("Expected object value")
            return
        }
        #expect(obj["default"] == nil)
    }

    @Test("boolean with default includes default key")
    func booleanWithDefault() {
        let schema = MCPSchema.boolean("Enabled", default: true)
        guard case .object(let obj) = schema else {
            Issue.record("Expected object value")
            return
        }
        #expect(obj["type"] == .string("boolean"))
        #expect(obj["default"] == .bool(true))
    }

    @Test("number produces correct structure")
    func numberSchema() {
        let schema = MCPSchema.number("Volume level")
        guard case .object(let obj) = schema else {
            Issue.record("Expected object value")
            return
        }
        #expect(obj["type"] == .string("number"))
        #expect(obj["description"] == .string("Volume level"))
    }

    @Test("stringArray produces correct items schema")
    func stringArraySchema() {
        let schema = MCPSchema.stringArray("List of IDs")
        guard case .object(let obj) = schema else {
            Issue.record("Expected object value")
            return
        }
        #expect(obj["type"] == .string("array"))
        #expect(obj["items"] == .object(["type": .string("string")]))
    }

    @Test("intArray produces correct items schema")
    func intArraySchema() {
        let schema = MCPSchema.intArray("Track IDs")
        guard case .object(let obj) = schema else {
            Issue.record("Expected object value")
            return
        }
        #expect(obj["type"] == .string("array"))
        #expect(obj["items"] == .object(["type": .string("integer")]))
    }

    @Test("stringMap produces additionalProperties schema")
    func stringMapSchema() {
        let schema = MCPSchema.stringMap("Tag fields")
        guard case .object(let obj) = schema else {
            Issue.record("Expected object value")
            return
        }
        #expect(obj["type"] == .string("object"))
        #expect(obj["additionalProperties"] == .object(["type": .string("string")]))
    }

    @Test("stringEnum includes enum values")
    func stringEnumSchema() {
        let schema = MCPSchema.stringEnum("Sort order", values: ["asc", "desc"])
        guard case .object(let obj) = schema else {
            Issue.record("Expected object value")
            return
        }
        #expect(obj["type"] == .string("string"))
        guard case .array(let values) = obj["enum"] else {
            Issue.record("Expected enum array")
            return
        }
        #expect(values == [.string("asc"), .string("desc")])
    }
}
