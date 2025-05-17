//
//  MovieDTO.swift
//  iTunesAppSuhyun
//
//  Created by 이수현 on 5/12/25.
//

import Foundation

struct MovieDTO: Decodable {
    let movieId: Int
    let title: String
    let artist: String
    let imageURL: String
    let price: Double
    let genre: String
    let contentAdvisoryRating: String
    let description: String
    let releaseDate: String
    let durationInMillis: Int
    let previewURL: String

    enum CodingKeys: String, CodingKey {
        case movieId = "trackId"
        case title = "trackName"
        case artist = "artistName"
        case imageURL = "artworkUrl100"
        case price = "trackPrice"
        case genre = "primaryGenreName"
        case contentAdvisoryRating = "contentAdvisoryRating"
        case description = "longDescription"
        case releaseDate
        case durationInMillis = "trackTimeMillis"
        case previewURL = "previewUrl"
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.movieId = try container.decode(Int.self, forKey: .movieId)
        self.title = try container.decode(String.self, forKey: .title)
        self.artist = try container.decode(String.self, forKey: .artist)
        self.imageURL = try container.decode(String.self, forKey: .imageURL)
        self.price = try container.decode(Double.self, forKey: .price)
        self.genre = try container.decode(String.self, forKey: .genre)
        self.contentAdvisoryRating = try container.decode(String.self, forKey: .contentAdvisoryRating)
        self.description = try container.decode(String.self, forKey: .description)
        self.releaseDate = try container.decode(String.self, forKey: .releaseDate)
        self.durationInMillis = try container.decodeIfPresent(Int.self, forKey: .durationInMillis) ?? 0
        self.previewURL = try container.decode(String.self, forKey: .previewURL)
    }
}
