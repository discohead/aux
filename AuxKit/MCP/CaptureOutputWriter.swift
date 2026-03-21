//
//  CaptureOutputWriter.swift
//  AuxKit
//
//  Created by Claude on 3/21/26.
//

import Foundation

/// Captures handler JSON output into a string, for use as MCP tool result content.
///
/// Thread-safety note: handlers call `write` exactly once before the caller reads
/// `capturedString`, so no concurrent access occurs.
public final class CaptureOutputWriter: OutputWriterProtocol, @unchecked Sendable {
    private var _capturedData: Data?

    public init() {}

    /// The captured JSON as a UTF-8 string, or nil if nothing was written.
    public var capturedString: String? {
        _capturedData.flatMap { String(data: $0, encoding: .utf8) }
    }

    public func write<T: Encodable & Sendable>(_ envelope: OutputEnvelope<T>) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        _capturedData = try encoder.encode(envelope)
    }

    public func writeError(_ error: CLIErrorResponse) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        _capturedData = try encoder.encode(error)
    }
}
