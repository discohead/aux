import Foundation
import Testing
@testable import AuxKit

struct PaginationHelperTests {
    @Test func fetchesSinglePage() async throws {
        let result = try await PaginationHelper.fetchAll(pageSize: 10) { limit, offset -> [String] in
            if offset == 0 { return ["a", "b", "c"] }
            return []
        }
        #expect(result == ["a", "b", "c"])
    }

    @Test func fetchesMultiplePages() async throws {
        let result = try await PaginationHelper.fetchAll(pageSize: 2) { limit, offset -> [String] in
            switch offset {
            case 0: return ["a", "b"]
            case 2: return ["c", "d"]
            case 4: return ["e"]
            default: return []
            }
        }
        #expect(result == ["a", "b", "c", "d", "e"])
    }

    @Test func stopsWhenPageSizeLessThanLimit() async throws {
        var callCount = 0
        let _ = try await PaginationHelper.fetchAll(pageSize: 5) { limit, offset -> [String] in
            callCount += 1
            if offset == 0 { return ["a", "b"] }
            return []
        }
        #expect(callCount == 1)
    }

    @Test func handlesEmptyResult() async throws {
        let result = try await PaginationHelper.fetchAll(pageSize: 10) { _, _ -> [String] in [] }
        #expect(result.isEmpty)
    }
}
