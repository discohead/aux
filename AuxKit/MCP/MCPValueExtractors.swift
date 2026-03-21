//
//  MCPValueExtractors.swift
//  AuxKit
//

import Foundation
import MCP

extension Optional where Wrapped == [String: Value] {

    /// Extract a required string argument. Throws `AuxError.usageError` if missing or not convertible.
    func requireString(_ key: String) throws -> String {
        guard let dict = self, let value = dict[key],
              let str = String(value, strict: false) else {
            throw AuxError.usageError(message: "Missing required argument: \(key)")
        }
        return str
    }

    /// Extract a required integer argument. Uses non-strict conversion to handle `.double` with exact values.
    func requireInt(_ key: String) throws -> Int {
        guard let dict = self, let value = dict[key],
              let int = Int(value, strict: false) else {
            throw AuxError.usageError(message: "Missing required argument: \(key)")
        }
        return int
    }

    /// Extract a required double argument. Handles both `.double` and `.int` values.
    func requireDouble(_ key: String) throws -> Double {
        guard let dict = self, let value = dict[key],
              let dbl = Double(value) else {
            throw AuxError.usageError(message: "Missing required argument: \(key)")
        }
        return dbl
    }

    /// Extract a required boolean argument. Throws `AuxError.usageError` if missing.
    func requireBool(_ key: String) throws -> Bool {
        guard let dict = self, let value = dict[key],
              let b = value.boolValue else {
            throw AuxError.usageError(message: "Missing required argument: \(key)")
        }
        return b
    }

    /// Extract an optional integer argument, returning nil if missing. Uses non-strict conversion.
    func optionalInt(_ key: String) -> Int? {
        guard let dict = self, let value = dict[key] else { return nil }
        return Int(value, strict: false)
    }

    /// Extract an optional integer argument with a default. Uses non-strict conversion.
    func optionalInt(_ key: String, default defaultValue: Int) -> Int {
        guard let dict = self, let value = dict[key],
              let int = Int(value, strict: false) else { return defaultValue }
        return int
    }

    /// Extract an optional double argument with a default. Handles `.int` → `Double`.
    func optionalDouble(_ key: String, default defaultValue: Double) -> Double {
        guard let dict = self, let value = dict[key],
              let dbl = Double(value) else { return defaultValue }
        return dbl
    }

    /// Extract an optional boolean argument with a default.
    func optionalBool(_ key: String, default defaultValue: Bool) -> Bool {
        guard let dict = self, let value = dict[key],
              let b = value.boolValue else { return defaultValue }
        return b
    }

    /// Extract an optional string argument, returning nil if missing.
    func optionalString(_ key: String) -> String? {
        guard let dict = self, let value = dict[key] else { return nil }
        return String(value, strict: false)
    }

    /// Extract an optional string array with a default. Uses compactMap for optional arrays.
    func optionalStringArray(_ key: String, default defaultValue: [String]) -> [String] {
        guard let dict = self, let arr = dict[key]?.arrayValue else { return defaultValue }
        return arr.compactMap { String($0, strict: false) }
    }

    /// Extract a required string array. Throws if any element cannot be converted.
    func requireStringArray(_ key: String) throws -> [String] {
        guard let dict = self, let arr = dict[key]?.arrayValue else {
            throw AuxError.usageError(message: "Missing required argument: \(key)")
        }
        return try arr.map { element in
            guard let s = String(element, strict: false) else {
                throw AuxError.usageError(message: "Invalid element in \(key): expected string-convertible value")
            }
            return s
        }
    }

    /// Extract a required integer array. Throws if any element cannot be converted.
    func requireIntArray(_ key: String) throws -> [Int] {
        guard let dict = self, let arr = dict[key]?.arrayValue else {
            throw AuxError.usageError(message: "Missing required argument: \(key)")
        }
        return try arr.map { element in
            guard let i = Int(element, strict: false) else {
                throw AuxError.usageError(message: "Invalid element in \(key): expected integer value")
            }
            return i
        }
    }

    /// Extract a required string map from an object. Converts non-string values via non-strict conversion.
    func requireStringMap(_ key: String) throws -> [String: String] {
        guard let dict = self, let obj = dict[key]?.objectValue else {
            throw AuxError.usageError(message: "Missing required argument: \(key)")
        }
        return try obj.reduce(into: [:]) { result, pair in
            guard let s = String(pair.value, strict: false) else {
                throw AuxError.usageError(
                    message: "Invalid value for key '\(pair.key)' in \(key): expected string-convertible value"
                )
            }
            result[pair.key] = s
        }
    }
}
