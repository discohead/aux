//
//  PaginationHelper.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/17/26.
//

import Foundation

/// A shared helper that auto-paginates through a fetcher closure until all pages are consumed.
public struct PaginationHelper {
    /// Fetches all pages by repeatedly calling `fetcher` with increasing offsets.
    /// Stops when a page returns fewer items than `pageSize`.
    public static func fetchAll<T: Codable & Sendable>(
        pageSize: Int = 25,
        fetcher: (_ limit: Int, _ offset: Int) async throws -> [T]
    ) async throws -> [T] {
        var allItems: [T] = []
        var offset = 0
        while true {
            let page = try await fetcher(pageSize, offset)
            allItems.append(contentsOf: page)
            if page.count < pageSize { break }
            offset += pageSize
        }
        return allItems
    }
}
