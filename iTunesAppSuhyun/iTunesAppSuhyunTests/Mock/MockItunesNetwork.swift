//
//  MockItunesNetwork.swift
//  iTunesAppSuhyunTests
//
//  Created by 이수현 on 5/10/25.
//

@testable import iTunesAppSuhyun
import Foundation

final class MockItunesNetwork: ITunesNetworkProtocol {
    func fetchData<T: Decodable>(keyword: String, country: String, limit: Int, media: String) async throws -> APIResponse<T> {
      return mockData() as! APIResponse<T>
    }
}

extension MockItunesNetwork {
    func mockData() -> APIResponse<MusicDTO> {
        return APIResponse<MusicDTO>(
            resultCount: 1,
            results: [
                MusicDTO(
                    musicId: 0,
                    title: "mockTitle",
                    artist:  "mockArtist",
                    album:  "mockAlbum",
                    genre: "mockGenre",
                    imageURL:  "mockImageURL",
                    releaseDate:  "2023-05-01T12:00:00Z",
                    durationInMillis: 0
                )
            ]
        )
    }
}
