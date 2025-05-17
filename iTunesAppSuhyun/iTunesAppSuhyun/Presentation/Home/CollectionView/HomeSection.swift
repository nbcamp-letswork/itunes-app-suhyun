//
//  HomeSection.swift
//  iTunesAppSuhyun
//
//  Created by 이수현 on 5/8/25.
//

import UIKit

enum HomeSection: Int, CaseIterable, Hashable {
    case spring
    case summer
    case autumn
    case winter
}

extension HomeSection {

    var keyword: String {
        switch self {
        case .spring: return "봄"
        case .summer: return "여름"
        case .autumn: return "가을"
        case .winter: return "겨울"
        }
    }

    var limit: Int {
        switch self {
        case .spring: return 10
        case .summer, .autumn: return 30
        case .winter: return 15
        }
    }

    var title: String {
        switch self {
        case .spring:
            "봄 Best"
        case .summer:
            "여름"
        case .autumn:
            "가을"
        case .winter:
            "겨울"
        }
    }

    var subTitle: String {
        switch self {
        case .spring:
            "봄에 어울리는 음악 Top 10"
        case .summer:
            "여름에 어울리는 음악"
        case .autumn:
            "가을에 어울리는 음악"
        case .winter:
            "겨울에 어울리는 음악"
        }
    }

    var section: NSCollectionLayoutSection {
        switch self {
        case .spring:
            return self.createBigBannerSection()
        case .summer:
            return self.createVerticalSection()
        case .autumn:
            return self.createVerticalSection()
        case .winter:
            return self.createBannerSection()
        }
    }

    func createItem(from music: Music) -> HomeItem {
        let item = HomeItem.MusicItem(from: music)
        switch self {
        case .spring: return .spring(item)
        case .summer: return .summer(item)
        case .autumn: return .autumn(item)
        case .winter: return .winter(item)
        }
    }
}

extension HomeSection {
    // 봄 섹션 (빅 배너)
    private func createBigBannerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 8,
            bottom: 0,
            trailing: 8
        )

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.9),
            heightDimension:. fractionalWidth(0.95)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.boundarySupplementaryItems = [createHeaderView()]
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 8
        )
        return section
    }

    // 여름, 가을 섹션 (vertical)
    private func createVerticalSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.3)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 8,
            trailing: 0
        )

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.9),
            heightDimension: .estimated(250)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            repeatingSubitem: item,
            count: 3
        )

        group.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 16
        )

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.boundarySupplementaryItems = [createHeaderView()]
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 32
        )
        return section
    }

    // 겨울 (배너 섹션)
    private func createBannerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 16
        )

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.45),
            heightDimension: .fractionalWidth(0.55)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [createHeaderView()]
        return section
    }

    private func createHeaderView() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(52)
        )
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }
}

enum HomeItem: Hashable {
    case spring(MusicItem)
    case summer(MusicItem)
    case autumn(MusicItem)
    case winter(MusicItem)

    var music: Music {
        switch self {
        case .spring(let musicItem), .summer(let musicItem), .autumn(let musicItem), .winter(let musicItem):
            return musicItem.toMusic()
        }
    }

    struct MusicItem: Hashable {
        let type: MediaType
        let musicId: Int
        let title: String
        let artist: String
        let album: String
        let genre: String
        let imageURL: String
        let releaseDate: Date
        let durationInSeconds: Int
        let previewURL: String
    }
}

extension HomeItem.MusicItem {
    init(from music: Music) {
        self.init(
            type: music.mediaInfo.type,
            musicId: music.mediaInfo.id,
            title: music.mediaInfo.title,
            artist: music.mediaInfo.artist,
            album: music.album,
            genre: music.mediaInfo.genre,
            imageURL: music.mediaInfo.imageURL,
            releaseDate: music.mediaInfo.releaseDate,
            durationInSeconds: music.mediaInfo.durationInSeconds,
            previewURL: music.previewURL
        )
    }

    func toMusic() -> Music {
        return Music(
            mediaInfo: MediaInfo(
                type: type,
                id: musicId,
                title: title,
                artist: artist,
                imageURL: imageURL,
                genre: genre,
                releaseDate: releaseDate,
                durationInSeconds: durationInSeconds
            ),
            album: album,
            previewURL: previewURL
        )
    }
}
