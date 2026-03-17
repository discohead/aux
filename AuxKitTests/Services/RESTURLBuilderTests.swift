import Testing
import Foundation
@testable import AuxKit

struct RESTURLBuilderTests {
    @Test func buildsSimplePath() {
        let url = RESTURLBuilder.buildURL(path: "/v1/catalog/us/songs/123")
        #expect(url?.absoluteString == "https://api.music.apple.com/v1/catalog/us/songs/123")
    }

    @Test func buildsPathWithQueryParams() {
        let url = RESTURLBuilder.buildURL(path: "/v1/me/library/songs", queryParams: ["limit": "25", "offset": "0"])
        #expect(url != nil)
        let str = url!.absoluteString
        #expect(str.contains("limit=25"))
        #expect(str.contains("offset=0"))
    }

    @Test func ratingsPathFormat() {
        let path = RESTURLBuilder.ratingsPath(type: "songs", id: "123")
        #expect(path == "/v1/me/ratings/songs/123")
    }

    @Test func libraryPathFormat() {
        let path = RESTURLBuilder.libraryPath("playlists")
        #expect(path == "/v1/me/library/playlists")
    }

    @Test func catalogPathFormat() {
        let path = RESTURLBuilder.catalogPath(storefront: "us", resource: "songs/123")
        #expect(path == "/v1/catalog/us/songs/123")
    }
}
