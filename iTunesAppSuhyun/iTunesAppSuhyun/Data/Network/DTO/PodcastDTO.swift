//
//  Podcast.swift
//  iTunesAppSuhyun
//
//  Created by 이수현 on 5/13/25.
//

import Foundation

struct PodcastDTO: Decodable {
    let podcastId: Int
    let title: String
    let artist: String
    let imageURL: String
    let genre: String
    let releaseDate: String
    let durationInMillis: Int

    enum CodingKeys: String, CodingKey {
        case podcastId = "trackId"
        case title = "trackName"
        case artist = "artistName"
        case imageURL = "artworkUrl600"
        case genre = "primaryGenreName"
        case releaseDate
        case durationInMillis = "trackTimeMillis"
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.podcastId = try container.decode(Int.self, forKey: .podcastId)
        self.title = try container.decode(String.self, forKey: .title)
        self.artist = try container.decode(String.self, forKey: .artist)
        self.imageURL = try container.decode(String.self, forKey: .imageURL)
        self.genre = try container.decode(String.self, forKey: .genre)
        self.releaseDate = try container.decode(String.self, forKey: .releaseDate)
        self.durationInMillis = try container.decodeIfPresent(Int.self, forKey: .durationInMillis) ?? 0
    }
}
