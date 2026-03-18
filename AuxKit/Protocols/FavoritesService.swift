//
//  FavoritesService.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/17/26.
//

import Foundation

/// Protocol for managing Apple Music favorites.
public protocol FavoritesService: Sendable {
    func addFavorite(type: String, id: String) async throws -> FavoriteResult
}
