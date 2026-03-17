//
//  FileInfoDTO.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// File-level metadata for a track.
public struct FileInfoDTO: Codable, Equatable, Sendable {
    public let databaseId: Int
    public let location: String?
    public let bitRate: Int?
    public let sampleRate: Int?
    public let size: Int?
    public let kind: String?
    public let duration: Double?
    public let dateAdded: String?
    public let dateModified: String?
    public let cloudStatus: String?

    enum CodingKeys: String, CodingKey {
        case databaseId = "database_id"
        case location, size, kind, duration
        case bitRate = "bit_rate"
        case sampleRate = "sample_rate"
        case dateAdded = "date_added"
        case dateModified = "date_modified"
        case cloudStatus = "cloud_status"
    }

    public init(
        databaseId: Int,
        location: String? = nil,
        bitRate: Int? = nil,
        sampleRate: Int? = nil,
        size: Int? = nil,
        kind: String? = nil,
        duration: Double? = nil,
        dateAdded: String? = nil,
        dateModified: String? = nil,
        cloudStatus: String? = nil
    ) {
        self.databaseId = databaseId
        self.location = location
        self.bitRate = bitRate
        self.sampleRate = sampleRate
        self.size = size
        self.kind = kind
        self.duration = duration
        self.dateAdded = dateAdded
        self.dateModified = dateModified
        self.cloudStatus = cloudStatus
    }

    public static func fixture(
        databaseId: Int = 1,
        location: String? = nil,
        bitRate: Int? = nil,
        sampleRate: Int? = nil,
        size: Int? = nil,
        kind: String? = nil,
        duration: Double? = nil,
        dateAdded: String? = nil,
        dateModified: String? = nil,
        cloudStatus: String? = nil
    ) -> FileInfoDTO {
        FileInfoDTO(
            databaseId: databaseId,
            location: location,
            bitRate: bitRate,
            sampleRate: sampleRate,
            size: size,
            kind: kind,
            duration: duration,
            dateAdded: dateAdded,
            dateModified: dateModified,
            cloudStatus: cloudStatus
        )
    }
}
