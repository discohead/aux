//
//  OutputEnvelope.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Pagination metadata included in list responses.
public struct PaginationMeta: Codable, Equatable, Sendable {
    public let limit: Int?
    public let offset: Int?
    public let total: Int?
    public let hasNext: Bool?

    public init(limit: Int? = nil, offset: Int? = nil, total: Int? = nil, hasNext: Bool? = nil) {
        self.limit = limit
        self.offset = offset
        self.total = total
        self.hasNext = hasNext
    }

    enum CodingKeys: String, CodingKey {
        case limit, offset, total
        case hasNext = "has_next"
    }
}

/// Standard success envelope — every command emits `{ "data": ..., "meta": ... }`.
public struct OutputEnvelope<T: Encodable>: Encodable where T: Sendable {
    public let data: T
    public let meta: PaginationMeta?

    public init(data: T, meta: PaginationMeta? = nil) {
        self.data = data
        self.meta = meta
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(data, forKey: .data)
        try container.encodeIfPresent(meta, forKey: .meta)
    }

    enum CodingKeys: String, CodingKey {
        case data, meta
    }
}
