//
//  ErrorPipelineTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Testing
import Foundation
@testable import AuxKit

struct ErrorPipelineTests {

    @Test func handlerErrorConvertsToResponse() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        mock.getSongResult = .failure(AuxError.notFound(message: "Song 999 not found"))

        do {
            try await CatalogSongHandler.handle(
                services: container, options: GlobalOptions(),
                id: "999", writer: JSONOutputWriter(destination: { _ in })
            )
            Issue.record("Expected error to be thrown")
        } catch let error as AuxError {
            let response = error.toCLIErrorResponse()
            let data = try JSONEncoder().encode(response)
            let parsed = try JSONSerialization.jsonObject(with: data)
            let json = try #require(parsed as? [String: Any])
            let errorObj = try #require(json["error"] as? [String: Any])
            #expect(errorObj["code"] as? String == "not_found")
            #expect(errorObj["message"] as? String == "Song 999 not found")
        }
    }

    @Test func authErrorProducesCorrectExitCode() async throws {
        let container = ServiceContainer.mock()
        let mock = container.auth as! MockAuthService
        mock.checkStatusResult = .failure(AuxError.notAuthorized(message: "denied"))

        do {
            try await AuthStatusHandler.handle(
                services: container, options: GlobalOptions(),
                writer: JSONOutputWriter(destination: { _ in })
            )
            Issue.record("Expected error")
        } catch let error as AuxError {
            #expect(error.exitCode.rawValue == 3) // notAuthorized
        }
    }

    @Test func appleScriptErrorProducesServiceErrorCode() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.playResult = .failure(AuxError.appleScriptError(message: "Music.app not running"))

        do {
            try await PlayHandler.handle(
                services: container, options: GlobalOptions(),
                writer: JSONOutputWriter(destination: { _ in })
            )
            Issue.record("Expected error")
        } catch let error as AuxError {
            #expect(error.exitCode == .serviceError)
            let response = error.toCLIErrorResponse()
            #expect(response.error.code == "applescript_error")
        }
    }

    @Test func errorResponseSerializesToJSON() throws {
        let response = CLIErrorResponse(code: "test_error", message: "Something went wrong")
        let data = try JSONEncoder().encode(response)
        let parsed = try JSONSerialization.jsonObject(with: data)
        let json = try #require(parsed as? [String: Any])
        let errorObj = try #require(json["error"] as? [String: Any])
        #expect(errorObj["code"] as? String == "test_error")
        #expect(errorObj["message"] as? String == "Something went wrong")
    }

    @Test func networkErrorSerializesWithCorrectFields() throws {
        let error = AuxError.networkError(message: "Connection timed out")
        let response = error.toCLIErrorResponse()
        let data = try JSONEncoder().encode(response)
        let parsed = try JSONSerialization.jsonObject(with: data)
        let json = try #require(parsed as? [String: Any])
        let errorObj = try #require(json["error"] as? [String: Any])
        #expect(errorObj["code"] as? String == "network_error")
        #expect(errorObj["message"] as? String == "Connection timed out")
        // details should be absent (nil)
        #expect(errorObj["details"] == nil)
    }

    @Test func allAuxErrorsProduceValidJSONResponses() throws {
        let errors: [AuxError] = [
            .notAuthorized(message: "auth msg"),
            .notFound(message: "not found msg"),
            .networkError(message: "net msg"),
            .serviceError(message: "svc msg"),
            .subscriptionRequired(message: "sub msg"),
            .unavailable(message: "unavail msg"),
            .generalFailure(message: "general msg"),
            .usageError(message: "usage msg"),
            .appleScriptError(message: "as msg"),
        ]

        for error in errors {
            let response = error.toCLIErrorResponse()
            let data = try JSONEncoder().encode(response)
            let parsed = try JSONSerialization.jsonObject(with: data)
            let json = try #require(parsed as? [String: Any])
            let errorObj = try #require(json["error"] as? [String: Any])
            #expect(errorObj["code"] as? String == error.code)
            #expect(errorObj["message"] as? String == error.message)
        }
    }
}
