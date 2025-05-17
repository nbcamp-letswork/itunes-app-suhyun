//
//  MusicDTO.swift
//  iTunesAppSuhyun
//
//  Created by 이수현 on 5/8/25.
//

import Foundation

struct MusicDTO: Decodable {
    let musicId: Int
    let title: String
    let artist: String
    let album: String
    let genre: String
    let imageURL: String
    let releaseDate: String
    let durationInMillis: Int
    let previewURL: String

    enum CodingKeys: String, CodingKey {
        case musicId = "trackId"
        case title = "trackName"
        case artist = "artistName"
        case album = "collectionName"
        case genre = "primaryGenreName"
        case imageURL = "artworkUrl100"
        case releaseDate
        case durationInMillis = "trackTimeMillis"
        case previewURL = "previewUrl"
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.musicId = try container.decode(Int.self, forKey: .musicId)
        self.title = try container.decode(String.self, forKey: .title)
        self.artist = try container.decode(String.self, forKey: .artist)
        self.album = try container.decodeIfPresent(String.self, forKey: .album) ?? "Unknown Album"
        self.genre = try container.decode(String.self, forKey: .genre)
        self.imageURL = try container.decode(String.self, forKey: .imageURL)
        self.releaseDate = try container.decode(String.self, forKey: .releaseDate)
        self.durationInMillis = try container.decodeIfPresent(Int.self, forKey: .durationInMillis) ?? 0
        self.previewURL = try container.decodeIfPresent(String.self, forKey: .previewURL) ?? ""
    }

    init(
        musicId: Int,
        title: String,
        artist: String,
        album: String,
        genre: String,
        imageURL: String,
        releaseDate: String,
        durationInMillis: Int,
        previewURL: String
    ) {
        self.musicId = musicId
        self.title = title
        self.artist = artist
        self.album = album
        self.genre = genre
        self.imageURL = imageURL
        self.releaseDate = releaseDate
        self.durationInMillis = durationInMillis
        self.previewURL = previewURL
    }
}
