//
//  MockAuthService.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Mock implementation of AuthService for testing.
public final class MockAuthService: AuthService, @unchecked Sendable {

    // MARK: - Call Tracking

    public var checkStatusCalled = false
    public var requestAuthorizationCalled = false
    public var getTokenCalled = false

    // MARK: - Configurable Results

    public var checkStatusResult: Result<AuthStatusResult, Error> = .success(
        AuthStatusResult(authorizationStatus: "authorized")
    )
    public var requestAuthorizationResult: Result<AuthStatusResult, Error> = .success(
        AuthStatusResult(authorizationStatus: "authorized")
    )
    public var getTokenResult: Result<TokenResult, Error> = .success(
        TokenResult(developerToken: "mock-dev-token", userToken: "mock-user-token", message: nil)
    )

    public init() {}

    // MARK: - Reset

    public func reset() {
        checkStatusCalled = false
        requestAuthorizationCalled = false
        getTokenCalled = false
    }

    // MARK: - Protocol Methods

    public func checkStatus() async throws -> AuthStatusResult {
        checkStatusCalled = true
        return try checkStatusResult.get()
    }

    public func requestAuthorization() async throws -> AuthStatusResult {
        requestAuthorizationCalled = true
        return try requestAuthorizationResult.get()
    }

    public func getToken(type: String) async throws -> TokenResult {
        getTokenCalled = true
        return try getTokenResult.get()
    }
}
