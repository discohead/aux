//
//  SummariesGetHandlerTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/17/26.
//

import Foundation
import Testing
@testable import AuxKit

struct SummariesGetHandlerTests {

    @Test func callsService() async throws {
        let container = ServiceContainer.mock()
        let mock = container.summaries as! MockSummariesService
        let writer = JSONOutputWriter(destination: { _ in })

        try await SummariesGetHandler.handle(
            services: container, options: GlobalOptions(), writer: writer
        )

        #expect(mock.getMusicSummariesCalled)
    }

    @Test func defaultsToYearLatest() async throws {
        let container = ServiceContainer.mock()
        let mock = container.summaries as! MockSummariesService
        let writer = JSONOutputWriter(destination: { _ in })

        try await SummariesGetHandler.handle(
            services: container, options: GlobalOptions(), writer: writer
        )

        #expect(mock.lastYear == "latest")
    }

    @Test func viewAllExpandsToAllThreeViews() async throws {
        let container = ServiceContainer.mock()
        let mock = container.summaries as! MockSummariesService
        let writer = JSONOutputWriter(destination: { _ in })

        try await SummariesGetHandler.handle(
            services: container, options: GlobalOptions(), views: ["all"], writer: writer
        )

        #expect(mock.lastViews == ["top-artists", "top-albums", "top-songs"])
    }

    @Test func specificViewPassedThrough() async throws {
        let container = ServiceContainer.mock()
        let mock = container.summaries as! MockSummariesService
        let writer = JSONOutputWriter(destination: { _ in })

        try await SummariesGetHandler.handle(
            services: container, options: GlobalOptions(), views: ["top-songs"], writer: writer
        )

        #expect(mock.lastViews == ["top-songs"])
    }

    @Test func validatesViewParam() async throws {
        let container = ServiceContainer.mock()
        let writer = JSONOutputWriter(destination: { _ in })

        await #expect(throws: AuxError.self) {
            try await SummariesGetHandler.handle(
                services: container, options: GlobalOptions(), views: ["invalid-view"], writer: writer
            )
        }
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.summaries as! MockSummariesService
        mock.getMusicSummariesResult = .failure(AuxError.serviceError(message: "Service unavailable"))

        await #expect(throws: AuxError.self) {
            try await SummariesGetHandler.handle(
                services: container, options: GlobalOptions(),
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}
