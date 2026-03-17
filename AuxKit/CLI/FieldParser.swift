//
//  FieldParser.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/17/26.
//

import Foundation

/// Shared utility for parsing key=value field pairs from comma-separated strings.
public enum FieldParser {

    /// Parses a comma-separated string of key=value pairs.
    /// Throws `AuxError.usageError` if no valid pairs are found or if any pair is malformed.
    public static func parse(_ raw: String) throws -> [String: String] {
        var result: [String: String] = [:]
        var malformed: [String] = []

        for pair in raw.split(separator: ",") {
            let trimmed = pair.trimmingCharacters(in: .whitespaces)
            let parts = trimmed.split(separator: "=", maxSplits: 1)
            if parts.count == 2 {
                result[String(parts[0])] = String(parts[1])
            } else {
                malformed.append(trimmed)
            }
        }

        if !malformed.isEmpty {
            throw AuxError.usageError(
                message: "Malformed field(s): \(malformed.joined(separator: ", ")). Expected format: key=value"
            )
        }

        if result.isEmpty {
            throw AuxError.usageError(message: "No valid key=value pairs provided")
        }

        return result
    }
}
