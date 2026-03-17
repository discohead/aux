//
//  AuthStatusHandlerTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation
import Testing
@testable import AuxKit

struct AuthStatusHandlerTests {

    @Test func checkStatusCallsAuthService() async throws {
        let container = ServiceContainer.mock()
        let mockAuth = container.auth as! MockAuthService
        let options = GlobalOptions(pretty: false, quiet: true)
        let writer = JSONOutputWriter(pretty: false, destination: { _ in })

        try await AuthStatusHandler.handle(services: container, options: options, writer: writer)

        #expect(mockAuth.checkStatusCalled)
    }

    @Test func checkStatusOutputContainsExpectedData() async throws {
        let container = ServiceContainer.mock()
        let mockAuth = container.auth as! MockAuthService
        let expected = AuthStatusResult(
            authorizationStatus: "authorized",
            subscription: SubscriptionInfo(
                canPlayCatalogContent: true,
                canBecomeSubscriber: false,
                hasCloudLibraryEnabled: true
            )
        )
        mockAuth.checkStatusResult = .success(expected)

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { data in
            capturedData = data
        })
        let options = GlobalOptions(pretty: false, quiet: true)

        try await AuthStatusHandler.handle(services: container, options: options, writer: writer)

        let data = try #require(capturedData)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        let dataObj = json["data"] as! [String: Any]
        #expect(dataObj["authorization_status"] as? String == "authorized")
        let sub = dataObj["subscription"] as! [String: Any]
        #expect(sub["can_play_catalog_content"] as? Bool == true)
        #expect(sub["has_cloud_library_enabled"] as? Bool == true)
    }

    @Test func checkStatusPropagatesError() async throws {
        let container = ServiceContainer.mock()
        let mockAuth = container.auth as! MockAuthService
        mockAuth.checkStatusResult = .failure(AuxError.notAuthorized(message: "Not authorized"))

        let writer = JSONOutputWriter(pretty: false, destination: { _ in })
        let options = GlobalOptions(pretty: false, quiet: true)

        await #expect(throws: AuxError.self) {
            try await AuthStatusHandler.handle(services: container, options: options, writer: writer)
        }
    }
}
