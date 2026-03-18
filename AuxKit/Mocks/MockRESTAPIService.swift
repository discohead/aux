//
//  MockRESTAPIService.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Mock implementation of RESTAPIService for testing.
public final class MockRESTAPIService: RESTAPIService, @unchecked Sendable {

    // MARK: - Call Tracking

    public var getCalled = false
    public var postCalled = false
    public var putCalled = false
    public var deleteCalled = false

    // MARK: - Parameter Tracking

    public var lastGetPath: String?
    public var lastGetQueryParams: [String: String]?

    // MARK: - Configurable Results

    public var getResult: Result<Data, Error> = .success(Data("{}".utf8))
    public var postResult: Result<Data, Error> = .success(Data("{}".utf8))
    public var putResult: Result<Data, Error> = .success(Data("{}".utf8))
    public var deleteResult: Result<Data, Error> = .success(Data("{}".utf8))

    public init() {}

    // MARK: - Reset

    public func reset() {
        getCalled = false
        postCalled = false
        putCalled = false
        deleteCalled = false
    }

    // MARK: - Protocol Methods

    public func get(path: String, queryParams: [String: String]?) async throws -> Data {
        getCalled = true
        lastGetPath = path
        lastGetQueryParams = queryParams
        return try getResult.get()
    }

    public func post(path: String, body: Data?) async throws -> Data {
        postCalled = true
        return try postResult.get()
    }

    public func put(path: String, body: Data?) async throws -> Data {
        putCalled = true
        return try putResult.get()
    }

    public func delete(path: String) async throws -> Data {
        deleteCalled = true
        return try deleteResult.get()
    }
}
