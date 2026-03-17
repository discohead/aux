import Testing
import Foundation
@testable import AuxKit

struct MusicKitToDTOMapperTests {
    @Test func formatDurationRoundsToTwoDecimals() {
        let result = MusicKitToDTOMapper.formatDuration(123.456789)
        #expect(result == 123.46)
    }

    @Test func formatDurationReturnsNilForNil() {
        #expect(MusicKitToDTOMapper.formatDuration(nil) == nil)
    }

    @Test func formatDateReturnsISO8601() {
        let date = Date(timeIntervalSince1970: 0)
        let result = MusicKitToDTOMapper.formatDate(date)
        #expect(result != nil)
        #expect(result!.contains("1970"))
    }

    @Test func formatDateReturnsNilForNil() {
        #expect(MusicKitToDTOMapper.formatDate(nil) == nil)
    }

    @Test func formatArtworkURLReplacesPlaceholders() {
        let url = URL(string: "https://example.com/img/{w}x{h}.jpg")!
        let result = MusicKitToDTOMapper.formatArtworkURL(url, width: 500, height: 500)
        #expect(result == "https://example.com/img/500x500.jpg")
    }

    @Test func formatArtworkURLReturnsNilForNil() {
        #expect(MusicKitToDTOMapper.formatArtworkURL(nil) == nil)
    }
}
