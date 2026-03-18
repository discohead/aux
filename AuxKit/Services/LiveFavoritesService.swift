//
//  LiveFavoritesService.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/17/26.
//

import Foundation
import MusicKit

/// Live implementation of FavoritesService using MusicDataRequest.
/// Favorites API uses POST with IDs as query parameters (not body).
@available(macOS 14.0, *)
public struct LiveFavoritesService: FavoritesService {

    public init() {}

    public func addFavorite(type: String, id: String) async throws -> FavoriteResult {
        var components = URLComponents(string: "https://api.music.apple.com/v1/me/favorites")!
        components.queryItems = [URLQueryItem(name: "ids[\(type)]", value: id)]

        var urlRequest = URLRequest(url: components.url!)
        urlRequest.httpMethod = "POST"

        let request = MusicDataRequest(urlRequest: urlRequest)
        let _ = try await request.response()

        return FavoriteResult(added: true, type: type, id: id)
    }
}
