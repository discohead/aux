//
//  MCPValueExtractorsTests.swift
//  AuxKitTests
//

import Testing
import MCP
@testable import AuxKit

@Suite("MCP Value Extractors Tests")
struct MCPValueExtractorsTests {

    // MARK: - requireString

    @Test("requireString extracts from .string")
    func requireStringFromString() throws {
        let args: [String: Value]? = ["query": .string("hello")]
        let result = try args.requireString("query")
        #expect(result == "hello")
    }

    @Test("requireString throws on missing key")
    func requireStringMissingKey() {
        let args: [String: Value]? = ["other": .string("hello")]
        #expect(throws: AuxError.self) {
            _ = try args.requireString("query")
        }
    }

    @Test("requireString throws on nil args")
    func requireStringNilArgs() {
        let args: [String: Value]? = nil
        #expect(throws: AuxError.self) {
            _ = try args.requireString("query")
        }
    }

    @Test("requireString throws on non-convertible type")
    func requireStringThrowsOnNull() {
        let args: [String: Value]? = ["query": .null]
        #expect(throws: AuxError.self) {
            _ = try args.requireString("query")
        }
    }

    // MARK: - requireInt

    @Test("requireInt extracts from .int")
    func requireIntFromInt() throws {
        let args: [String: Value]? = ["id": .int(42)]
        let result = try args.requireInt("id")
        #expect(result == 42)
    }

    @Test("requireInt converts from .double with exact value")
    func requireIntFromDoubleExact() throws {
        let args: [String: Value]? = ["id": .double(42.0)]
        let result = try args.requireInt("id")
        #expect(result == 42)
    }

    @Test("requireInt throws on .double with fractional value")
    func requireIntFromDoubleFractional() {
        let args: [String: Value]? = ["id": .double(42.5)]
        #expect(throws: AuxError.self) {
            _ = try args.requireInt("id")
        }
    }

    @Test("requireInt throws on missing key")
    func requireIntMissingKey() {
        let args: [String: Value]? = ["other": .int(1)]
        #expect(throws: AuxError.self) {
            _ = try args.requireInt("id")
        }
    }

    @Test("requireInt throws on nil args")
    func requireIntNilArgs() {
        let args: [String: Value]? = nil
        #expect(throws: AuxError.self) {
            _ = try args.requireInt("id")
        }
    }

    // MARK: - requireDouble

    @Test("requireDouble extracts from .double")
    func requireDoubleFromDouble() throws {
        let args: [String: Value]? = ["position": .double(3.14)]
        let result = try args.requireDouble("position")
        #expect(result == 3.14)
    }

    @Test("requireDouble converts from .int")
    func requireDoubleFromInt() throws {
        let args: [String: Value]? = ["position": .int(42)]
        let result = try args.requireDouble("position")
        #expect(result == 42.0)
    }

    @Test("requireDouble throws on missing key")
    func requireDoubleMissingKey() {
        let args: [String: Value]? = [:]
        #expect(throws: AuxError.self) {
            _ = try args.requireDouble("position")
        }
    }

    // MARK: - requireBool

    @Test("requireBool extracts from .bool")
    func requireBoolFromBool() throws {
        let args: [String: Value]? = ["enabled": .bool(true)]
        let result = try args.requireBool("enabled")
        #expect(result == true)
    }

    @Test("requireBool throws on missing key")
    func requireBoolMissingKey() {
        let args: [String: Value]? = [:]
        #expect(throws: AuxError.self) {
            _ = try args.requireBool("enabled")
        }
    }

    // MARK: - optionalInt

    @Test("optionalInt returns value from .int")
    func optionalIntFromInt() {
        let args: [String: Value]? = ["limit": .int(10)]
        let result = args.optionalInt("limit", default: 25)
        #expect(result == 10)
    }

    @Test("optionalInt returns default when key missing")
    func optionalIntMissing() {
        let args: [String: Value]? = [:]
        let result = args.optionalInt("limit", default: 25)
        #expect(result == 25)
    }

    @Test("optionalInt returns default when args nil")
    func optionalIntNilArgs() {
        let args: [String: Value]? = nil
        let result = args.optionalInt("limit", default: 25)
        #expect(result == 25)
    }

    @Test("optionalInt converts from .double with exact value")
    func optionalIntFromDouble() {
        let args: [String: Value]? = ["limit": .double(10.0)]
        let result = args.optionalInt("limit", default: 25)
        #expect(result == 10)
    }

    @Test("optionalInt returns default for .double with fractional value")
    func optionalIntFromDoubleFractional() {
        let args: [String: Value]? = ["limit": .double(10.5)]
        let result = args.optionalInt("limit", default: 25)
        #expect(result == 25)
    }

    // MARK: - optionalDouble

    @Test("optionalDouble returns value from .double")
    func optionalDoubleFromDouble() {
        let args: [String: Value]? = ["seconds": .double(30.5)]
        let result = args.optionalDouble("seconds", default: 15.0)
        #expect(result == 30.5)
    }

    @Test("optionalDouble returns default when missing")
    func optionalDoubleMissing() {
        let args: [String: Value]? = [:]
        let result = args.optionalDouble("seconds", default: 15.0)
        #expect(result == 15.0)
    }

    @Test("optionalDouble converts from .int")
    func optionalDoubleFromInt() {
        let args: [String: Value]? = ["seconds": .int(30)]
        let result = args.optionalDouble("seconds", default: 15.0)
        #expect(result == 30.0)
    }

    // MARK: - optionalBool

    @Test("optionalBool returns value from .bool")
    func optionalBoolFromBool() {
        let args: [String: Value]? = ["shuffle": .bool(true)]
        let result = args.optionalBool("shuffle", default: false)
        #expect(result == true)
    }

    @Test("optionalBool returns default when missing")
    func optionalBoolMissing() {
        let args: [String: Value]? = [:]
        let result = args.optionalBool("shuffle", default: false)
        #expect(result == false)
    }

    // MARK: - optionalString

    @Test("optionalString returns value when present")
    func optionalStringPresent() {
        let args: [String: Value]? = ["name": .string("hello")]
        let result = args.optionalString("name")
        #expect(result == "hello")
    }

    @Test("optionalString returns nil when missing")
    func optionalStringMissing() {
        let args: [String: Value]? = [:]
        let result = args.optionalString("name")
        #expect(result == nil)
    }

    @Test("optionalString returns nil when args nil")
    func optionalStringNilArgs() {
        let args: [String: Value]? = nil
        let result = args.optionalString("name")
        #expect(result == nil)
    }

    // MARK: - optionalStringArray

    @Test("optionalStringArray returns array when present")
    func optionalStringArrayPresent() {
        let args: [String: Value]? = ["types": .array([.string("songs"), .string("albums")])]
        let result = args.optionalStringArray("types", default: ["songs"])
        #expect(result == ["songs", "albums"])
    }

    @Test("optionalStringArray returns default when missing")
    func optionalStringArrayMissing() {
        let args: [String: Value]? = [:]
        let result = args.optionalStringArray("types", default: ["songs"])
        #expect(result == ["songs"])
    }

    // MARK: - requireStringArray

    @Test("requireStringArray extracts string array")
    func requireStringArrayValid() throws {
        let args: [String: Value]? = ["ids": .array([.string("a"), .string("b")])]
        let result = try args.requireStringArray("ids")
        #expect(result == ["a", "b"])
    }

    @Test("requireStringArray throws on missing key")
    func requireStringArrayMissing() {
        let args: [String: Value]? = [:]
        #expect(throws: AuxError.self) {
            _ = try args.requireStringArray("ids")
        }
    }

    @Test("requireStringArray throws if element not convertible")
    func requireStringArrayInvalidElement() {
        let args: [String: Value]? = ["ids": .array([.string("a"), .null])]
        #expect(throws: AuxError.self) {
            _ = try args.requireStringArray("ids")
        }
    }

    @Test("requireStringArray converts int elements via non-strict")
    func requireStringArrayConvertsInts() throws {
        let args: [String: Value]? = ["ids": .array([.string("a"), .int(42)])]
        let result = try args.requireStringArray("ids")
        #expect(result == ["a", "42"])
    }

    // MARK: - requireIntArray

    @Test("requireIntArray extracts int array")
    func requireIntArrayValid() throws {
        let args: [String: Value]? = ["track_ids": .array([.int(1), .int(2), .int(3)])]
        let result = try args.requireIntArray("track_ids")
        #expect(result == [1, 2, 3])
    }

    @Test("requireIntArray throws on missing key")
    func requireIntArrayMissing() {
        let args: [String: Value]? = [:]
        #expect(throws: AuxError.self) {
            _ = try args.requireIntArray("track_ids")
        }
    }

    @Test("requireIntArray converts .double elements with exact values")
    func requireIntArrayFromDoubles() throws {
        let args: [String: Value]? = ["track_ids": .array([.double(1.0), .double(2.0)])]
        let result = try args.requireIntArray("track_ids")
        #expect(result == [1, 2])
    }

    @Test("requireIntArray throws if element has fractional value")
    func requireIntArrayFractionalElement() {
        let args: [String: Value]? = ["track_ids": .array([.int(1), .double(2.5)])]
        #expect(throws: AuxError.self) {
            _ = try args.requireIntArray("track_ids")
        }
    }

    // MARK: - requireStringMap

    @Test("requireStringMap extracts string object")
    func requireStringMapValid() throws {
        let args: [String: Value]? = ["fields": .object(["name": .string("hello"), "genre": .string("rock")])]
        let result = try args.requireStringMap("fields")
        #expect(result == ["name": "hello", "genre": "rock"])
    }

    @Test("requireStringMap throws on missing key")
    func requireStringMapMissing() {
        let args: [String: Value]? = [:]
        #expect(throws: AuxError.self) {
            _ = try args.requireStringMap("fields")
        }
    }

    @Test("requireStringMap converts non-string values via non-strict")
    func requireStringMapConvertsValues() throws {
        let args: [String: Value]? = ["fields": .object(["count": .int(5), "active": .bool(true)])]
        let result = try args.requireStringMap("fields")
        #expect(result["count"] == "5")
        #expect(result["active"] == "true")
    }

    @Test("requireStringMap throws if value not an object")
    func requireStringMapNotObject() {
        let args: [String: Value]? = ["fields": .string("not an object")]
        #expect(throws: AuxError.self) {
            _ = try args.requireStringMap("fields")
        }
    }

    @Test("requireStringMap throws if value contains null")
    func requireStringMapNullValue() {
        let args: [String: Value]? = ["fields": .object(["key": .null])]
        #expect(throws: AuxError.self) {
            _ = try args.requireStringMap("fields")
        }
    }
}
