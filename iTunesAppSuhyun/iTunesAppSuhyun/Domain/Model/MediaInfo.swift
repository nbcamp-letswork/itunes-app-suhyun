//
//  MediaInfo.swift
//  iTunesAppSuhyun
//
//  Created by 이수현 on 5/15/25.
//

import Foundation

struct MediaInfo {
    let type: MediaType
    let id: Int
    let title: String
    let artist: String
    let imageURL: String
    let genre: String
    let releaseDate: Date
    let durationInSeconds: Int
}
