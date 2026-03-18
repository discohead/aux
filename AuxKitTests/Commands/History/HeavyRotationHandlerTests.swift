import Foundation
import Testing
@testable import AuxKit

struct HeavyRotationHandlerTests {

    @Test func callsHistoryService() async throws {
        let container = ServiceContainer.mock()
        let mock = container.history as! MockHistoryService

        try await HeavyRotationHandler.handle(
            services: container, options: GlobalOptions(),
            writer: JSONOutputWriter(destination: { _ in })
        )
        #expect(mock.getHeavyRotationCalled)
    }

    @Test func writesResultWithPaginationMeta() async throws {
        let container = ServiceContainer.mock()
        let mock = container.history as! MockHistoryService
        mock.getHeavyRotationResult = .success(
            HeavyRotationResult(items: [HeavyRotationItem.fixture()])
        )

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await HeavyRotationHandler.handle(
            services: container, options: GlobalOptions(), writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"data\""))
        #expect(json.contains("\"meta\""))
        #expect(json.contains("\"items\""))
    }

    @Test func passesLimitToService() async throws {
        let container = ServiceContainer.mock()
        let mock = container.history as! MockHistoryService

        try await HeavyRotationHandler.handle(
            services: container, options: GlobalOptions(),
            limit: 10, writer: JSONOutputWriter(destination: { _ in })
        )
        #expect(mock.getHeavyRotationCalled)
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        (container.history as! MockHistoryService).getHeavyRotationResult = .failure(
            AuxError.networkError(message: "offline")
        )

        await #expect(throws: AuxError.self) {
            try await HeavyRotationHandler.handle(
                services: container, options: GlobalOptions(),
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}
