//
//  MovieRepository.swift
//  iTunesAppSuhyun
//
//  Created by 이수현 on 5/13/25.
//

import Foundation

final class MovieRepository: MovieRepositoryProtocol {
    private let service: ITunesNetworkProtocol

    init(service: ITunesNetworkProtocol) {
        self.service = service
    }

    func fetchMovie(keyword: String, country: String, limit: Int) async throws -> [Movie] {
        do {
            let result: APIResponse<MovieDTO> = try await service.fetchData(
                keyword: keyword,
                country: country,
                limit: limit,
                media: MediaType.movie.media
            )
            return transfrom(from: result.results)
        } catch {
            if let error = error as? NetworkError {
                throw AppError.networkError(error)
            } else {
                throw AppError.unKnown(error)
            }
        }
    }

    private func transfrom(from results: [MovieDTO]) -> [Movie] {
        return results.compactMap { (dto: MovieDTO) -> Movie? in
            guard let date = Date(iso8601String: dto.releaseDate) else{ return nil }
            let mediaInfo = MediaInfo(
                type: .movie,
                id: dto.movieId,
                title: dto.title,
                artist: dto.artist,
                imageURL: dto.imageURL,
                genre: dto.genre,
                releaseDate: date,
                durationInSeconds: dto.durationInMillis / 1000
            )
            return Movie(
                mediaInfo: mediaInfo,
                contentAdvisoryRating: dto.contentAdvisoryRating,
                price: dto.price,
                description: dto.description,
                previewURL: dto.previewURL
            )
        }
    }
}
