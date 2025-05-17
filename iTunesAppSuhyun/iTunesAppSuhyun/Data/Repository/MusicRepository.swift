//
//  MusicRepository.swift
//  iTunesAppSuhyun
//
//  Created by 이수현 on 5/9/25.
//

import Foundation

final class MusicRepository: MusicRepositoryProtocol {

    private let service: ITunesNetworkProtocol

    init(service: ITunesNetworkProtocol) {
        self.service = service
    }

    func fetchMusic(keyword: String, country: String, limit: Int) async throws -> [Music] {
        do {
            let result: APIResponse<MusicDTO> = try await service.fetchData(
                    keyword: keyword,
                    country: country,
                    limit: limit,
                    media: MediaType.music.media
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

    private func transfrom(from results: [MusicDTO]) -> [Music] {
        return results.compactMap { (dto: MusicDTO) -> Music? in
            guard let date = Date(iso8601String: dto.releaseDate) else{ return nil }
            let mediaInfo = MediaInfo(
                type: .music,
                id: dto.musicId,
                title: dto.title,
                artist: dto.artist,
                imageURL: dto.imageURL,
                genre: dto.genre,
                releaseDate: date,
                durationInSeconds: dto.durationInMillis / 1000
            )
            return Music(
                mediaInfo: mediaInfo,
                album: dto.album,
                previewURL: dto.previewURL
            )
        }
    }
}
