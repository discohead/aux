//
//  AuthTokenHandlerTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation
import Testing
@testable import AuxKit

struct AuthTokenHandlerTests {

    @Test func getTokenCallsAuthService() async throws {
        let container = ServiceContainer.mock()
        let mockAuth = container.auth as! MockAuthService
        let options = GlobalOptions(pretty: false, quiet: true)
        let writer = JSONOutputWriter(pretty: false, destination: { _ in })

        try await AuthTokenHandler.handle(
            services: container, options: options, type: "developer", writer: writer
        )

        #expect(mockAuth.getTokenCalled)
    }

    @Test func getTokenOutputContainsExpectedData() async throws {
        let container = ServiceContainer.mock()
        let mockAuth = container.auth as! MockAuthService
        let expected = TokenResult(developerToken: "dev-123", userToken: nil)
        mockAuth.getTokenResult = .success(expected)

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { data in
            capturedData = data
        })
        let options = GlobalOptions(pretty: false, quiet: true)

        try await AuthTokenHandler.handle(
            services: container, options: options, type: "developer", writer: writer
        )

        let data = try #require(capturedData)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        let dataObj = json["data"] as! [String: Any]
        #expect(dataObj["developer_token"] as? String == "dev-123")
    }

    @Test func getTokenPropagatesError() async throws {
        let container = ServiceContainer.mock()
        let mockAuth = container.auth as! MockAuthService
        mockAuth.getTokenResult = .failure(
            AuxError.notAuthorized(message: "Token retrieval requires authorization")
        )

        let writer = JSONOutputWriter(pretty: false, destination: { _ in })
        let options = GlobalOptions(pretty: false, quiet: true)

        await #expect(throws: AuxError.self) {
            try await AuthTokenHandler.handle(
                services: container, options: options, type: "user", writer: writer
            )
        }
    }
}
