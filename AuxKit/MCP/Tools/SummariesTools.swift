import Foundation
import MCP

extension AuxToolRegistry {
    static func summariesTools() -> [AuxToolDefinition] {
        [
            AuxToolDefinition(
                name: "aux_summaries_get",
                description: "Get Apple Music Summaries (Replay) data including top artists, albums, and songs",
                inputSchema: MCPSchema.object(
                    properties: [
                        "year": MCPSchema.string("Year to retrieve (e.g. '2024') or 'latest'"),
                        "views": MCPSchema.stringArray("Views to include: top-artists, top-albums, top-songs, all"),
                    ]
                ),
                annotations: Tool.Annotations(readOnlyHint: true)
            ) { services, args in
                let year = args?["year"]?.stringValue ?? "latest"
                let views = args?["views"]?.arrayValue?.compactMap(\.stringValue) ?? ["all"]
                let writer = CaptureOutputWriter()
                try await SummariesGetHandler.handle(
                    services: services,
                    options: GlobalOptions(pretty: true),
                    year: year,
                    views: views,
                    writer: writer
                )
                return writer.capturedString ?? "{}"
            },
        ]
    }
}
