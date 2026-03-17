//
//  LiveRESTAPIService.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation
import MusicKit

/// Live implementation of RESTAPIService using MusicDataRequest.
/// MusicDataRequest automatically handles developer and user token injection.
public final class LiveRESTAPIService: RESTAPIService, Sendable {
    public init() {}

    public func get(path: String, queryParams: [String: String]?) async throws -> Data {
        var urlRequest = try buildRequest(path: path, method: "GET")
        if let params = queryParams, !params.isEmpty {
            guard var components = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: false) else {
                throw AuxError.usageError(message: "Invalid URL components for path: \(path)")
            }
            components.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
            urlRequest.url = components.url
        }
        let request = MusicDataRequest(urlRequest: urlRequest)
        let response = try await request.response()
        return response.data
    }

    public func post(path: String, body: Data?) async throws -> Data {
        var urlRequest = try buildRequest(path: path, method: "POST")
        urlRequest.httpBody = body
        let request = MusicDataRequest(urlRequest: urlRequest)
        let response = try await request.response()
        return response.data
    }

    public func put(path: String, body: Data?) async throws -> Data {
        var urlRequest = try buildRequest(path: path, method: "PUT")
        urlRequest.httpBody = body
        let request = MusicDataRequest(urlRequest: urlRequest)
        let response = try await request.response()
        return response.data
    }

    public func delete(path: String) async throws -> Data {
        let urlRequest = try buildRequest(path: path, method: "DELETE")
        let request = MusicDataRequest(urlRequest: urlRequest)
        let response = try await request.response()
        return response.data
    }

    // MARK: - Private

    private func buildRequest(path: String, method: String) throws -> URLRequest {
        let baseURL = "https://api.music.apple.com"
        let fullPath = path.hasPrefix("/") ? path : "/\(path)"
        guard let url = URL(string: baseURL + fullPath) else {
            throw AuxError.usageError(message: "Invalid API path: \(path)")
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}
