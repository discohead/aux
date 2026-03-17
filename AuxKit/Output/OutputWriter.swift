//
//  OutputWriter.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Protocol for writing structured output from commands.
public protocol OutputWriterProtocol: Sendable {
    func write<T: Encodable & Sendable>(_ envelope: OutputEnvelope<T>) throws
    func writeError(_ error: CLIErrorResponse) throws
}

/// Writes JSON to a configurable destination (stdout by default).
public struct JSONOutputWriter: OutputWriterProtocol, Sendable {
    private let pretty: Bool
    private let destination: @Sendable (Data) -> Void

    public init(
        pretty: Bool = false,
        destination: @escaping @Sendable (Data) -> Void = { data in
            FileHandle.standardOutput.write(data)
            FileHandle.standardOutput.write(Data("\n".utf8))
        }
    ) {
        self.pretty = pretty
        self.destination = destination
    }

    private func makeEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        if pretty {
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        }
        return encoder
    }

    public func write<T: Encodable & Sendable>(_ envelope: OutputEnvelope<T>) throws {
        let data = try makeEncoder().encode(envelope)
        destination(data)
    }

    public func writeError(_ error: CLIErrorResponse) throws {
        let data = try makeEncoder().encode(error)
        destination(data)
    }
}

/// TextOutputStream that writes to stderr.
public struct StderrOutputStream: TextOutputStream, Sendable {
    public init() {}

    public mutating func write(_ string: String) {
        FileHandle.standardError.write(Data(string.utf8))
    }
}
