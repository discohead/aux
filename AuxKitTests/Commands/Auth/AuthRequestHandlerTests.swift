//
//  AuthRequestHandlerTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation
import Testing
@testable import AuxKit

struct AuthRequestHandlerTests {

    @Test func requestAuthorizationCallsAuthService() async throws {
        let container = ServiceContainer.mock()
        let mockAuth = container.auth as! MockAuthService
        let options = GlobalOptions(pretty: false, quiet: true)
        let writer = JSONOutputWriter(pretty: false, destination: { _ in })

        try await AuthRequestHandler.handle(services: container, options: options, writer: writer)

        #expect(mockAuth.requestAuthorizationCalled)
    }

    @Test func requestAuthorizationOutputContainsExpectedData() async throws {
        let container = ServiceContainer.mock()
        let mockAuth = container.auth as! MockAuthService
        let expected = AuthStatusResult(authorizationStatus: "authorized")
        mockAuth.requestAuthorizationResult = .success(expected)

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { data in
            capturedData = data
        })
        let options = GlobalOptions(pretty: false, quiet: true)

        try await AuthRequestHandler.handle(services: container, options: options, writer: writer)

        let data = try #require(capturedData)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        let dataObj = json["data"] as! [String: Any]
        #expect(dataObj["authorization_status"] as? String == "authorized")
        #expect(dataObj["subscription"] == nil)
    }

    @Test func requestAuthorizationPropagatesError() async throws {
        let container = ServiceContainer.mock()
        let mockAuth = container.auth as! MockAuthService
        mockAuth.requestAuthorizationResult = .failure(
            AuxError.serviceError(message: "Authorization failed")
        )

        let writer = JSONOutputWriter(pretty: false, destination: { _ in })
        let options = GlobalOptions(pretty: false, quiet: true)

        await #expect(throws: AuxError.self) {
            try await AuthRequestHandler.handle(services: container, options: options, writer: writer)
        }
    }
}
