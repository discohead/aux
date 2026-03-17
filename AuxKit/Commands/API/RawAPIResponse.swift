//
//  RawAPIResponse.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Wraps raw API response data for JSON output.
public struct RawAPIResponse: Codable, Equatable, Sendable {
    public let statusCode: Int
    public let body: String

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case body
    }

    public init(statusCode: Int = 200, data: Data) {
        self.statusCode = statusCode
        self.body = String(data: data, encoding: .utf8) ?? ""
    }

    public init(statusCode: Int = 200, body: String) {
        self.statusCode = statusCode
        self.body = body
    }
}
