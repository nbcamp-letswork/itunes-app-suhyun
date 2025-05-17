//
//  PodcastRepository.swift
//  iTunesAppSuhyun
//
//  Created by 이수현 on 5/13/25.
//

import Foundation

final class PodcastRepository: PodcastRepositoryProtocol {
    private let service: ITunesNetworkProtocol

    init(service: ITunesNetworkProtocol) {
        self.service = service
    }

    func fetchPodcast(keyword: String, country: String, limit: Int) async throws -> [Podcast] {
        do {
            let result: APIResponse<PodcastDTO> = try await service.fetchData(
                keyword: keyword,
                country: country,
                limit: limit,
                media: MediaType.podcast.media
            )
            return transform(from: result.results)
        } catch {
            if let error = error as? NetworkError {
                throw AppError.networkError(error)
            } else {
                throw AppError.unKnown(error)
            }
        }
    }

    private func transform(from results: [PodcastDTO]) -> [Podcast] {
        return results.compactMap { dto -> Podcast? in
            guard let date = Date(iso8601String: dto.releaseDate) else{ return nil }
            let mediaInfo = MediaInfo(
                type: .podcast,
                id: dto.podcastId,
                title: dto.title,
                artist: dto.artist,
                imageURL: dto.imageURL,
                genre: dto.genre,
                releaseDate: date,
                durationInSeconds: dto.durationInMillis / 1000
            )
            return Podcast(mediaInfo: mediaInfo)
        }
    }
}
