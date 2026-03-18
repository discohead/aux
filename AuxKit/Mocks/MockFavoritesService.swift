//
//  MockFavoritesService.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/17/26.
//

import Foundation

/// Mock implementation of FavoritesService for testing.
public final class MockFavoritesService: FavoritesService, @unchecked Sendable {

    // MARK: - Call Tracking

    public var addFavoriteCalled = false

    // MARK: - Configurable Results

    public var addFavoriteResult: Result<FavoriteResult, Error> = .success(
        FavoriteResult(added: true, type: "songs", id: "1")
    )

    public init() {}

    // MARK: - Reset

    public func reset() {
        addFavoriteCalled = false
    }

    // MARK: - Protocol Methods

    public func addFavorite(type: String, id: String) async throws -> FavoriteResult {
        addFavoriteCalled = true
        return try addFavoriteResult.get()
    }
}
