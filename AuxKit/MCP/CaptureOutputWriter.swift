//
//  CaptureOutputWriter.swift
//  AuxKit
//
//  Created by Claude on 3/21/26.
//

import Foundation
import os

/// Captures handler JSON output into a string, for use as MCP tool result content.
///
/// Thread-safety: uses `OSAllocatedUnfairLock` to protect mutable state.
/// Enforces single-write semantics — calling `write` or `writeError` more than once
/// triggers a precondition failure.
public final class CaptureOutputWriter: OutputWriterProtocol, @unchecked Sendable {
    private let storage = OSAllocatedUnfairLock<Data?>(initialState: nil)

    public init() {}

    /// The captured JSON as a UTF-8 string, or nil if nothing was written.
    public var capturedString: String? {
        storage.withLock { data in
            data.flatMap { String(data: $0, encoding: .utf8) }
        }
    }

    public func write<T: Encodable & Sendable>(_ envelope: OutputEnvelope<T>) throws {
        try encodeAndStore(envelope)
    }

    public func writeError(_ error: CLIErrorResponse) throws {
        try encodeAndStore(error)
    }

    private func encodeAndStore<T: Encodable>(_ value: T) throws {
        let encoder = JSONEncoder.aux
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let encoded = try encoder.encode(value)
        storage.withLock { data in
            precondition(data == nil, "CaptureOutputWriter: write called more than once")
            data = encoded
        }
    }

    /// Executes a handler block, captures its output, and returns the JSON string.
    /// Throws if the handler throws or produces no output.
    public static func capture(
        services: ServiceContainer,
        options: GlobalOptions = .pretty,
        _ block: (ServiceContainer, GlobalOptions, CaptureOutputWriter) async throws -> Void
    ) async throws -> String {
        let writer = CaptureOutputWriter()
        try await block(services, options, writer)
        guard let result = writer.capturedString else {
            throw AuxError.serviceError(message: "Handler produced no output")
        }
        return result
    }
}
