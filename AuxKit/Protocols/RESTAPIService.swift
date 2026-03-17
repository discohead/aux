//
//  RESTAPIService.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Protocol defining low-level REST API operations for the Apple Music API.
public protocol RESTAPIService: Sendable {
    func get(path: String, queryParams: [String: String]?) async throws -> Data
    func post(path: String, body: Data?) async throws -> Data
    func put(path: String, body: Data?) async throws -> Data
    func delete(path: String) async throws -> Data
}
