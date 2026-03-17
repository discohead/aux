//
//  CLIErrorResponse.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Lightweight type-erased Codable wrapper for heterogeneous detail values.
public struct AnyCodable: Encodable, Sendable {
    private let _encode: @Sendable (Encoder) throws -> Void

    public init<T: Encodable & Sendable>(_ value: T) {
        _encode = { encoder in try value.encode(to: encoder) }
    }

    public func encode(to encoder: Encoder) throws {
        try _encode(encoder)
    }
}

/// Standard error envelope — `{ "error": { "code": ..., "message": ..., "details": ... } }`.
public struct CLIErrorResponse: Encodable, Sendable {
    public let error: ErrorBody

    public struct ErrorBody: Encodable, Sendable {
        public let code: String
        public let message: String
        public let details: [String: AnyCodable]?
    }

    public init(code: String, message: String, details: [String: AnyCodable]? = nil) {
        self.error = ErrorBody(code: code, message: message, details: details)
    }
}
