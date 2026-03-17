import Testing
import Foundation
@testable import AuxKit

struct AppleScriptBuilderTests {
    @Test func tellWrapsCommand() {
        let script = AppleScriptBuilder.tell("play")
        #expect(script == "tell application \"Music\" to play")
    }

    @Test func playCommandWithoutTrackId() {
        let script = AppleScriptBuilder.playCommand()
        #expect(script.contains("to play"))
        #expect(!script.contains("database ID"))
    }

    @Test func playCommandWithTrackId() {
        let script = AppleScriptBuilder.playCommand(trackId: 42)
        #expect(script.contains("database ID is 42"))
    }

    @Test func escapeStringHandlesQuotes() {
        let result = AppleScriptBuilder.escapeString("He said \"hello\"")
        #expect(result == "He said \\\"hello\\\"")
    }

    @Test func volumeCommandClampsToInt() {
        let script = AppleScriptBuilder.volumeCommand(75.5)
        #expect(script.contains("75"))
    }

    @Test func seekCommandSetsPosition() {
        let script = AppleScriptBuilder.seekCommand(position: 42.5)
        #expect(script.contains("42.5"))
    }
}
