//
//  MediaType.swift
//  iTunesAppSuhyun
//
//  Created by 이수현 on 5/13/25.
//

import Foundation

enum MediaType: String {
    case music
    case movie
    case podcast

    var media: String {
        self.rawValue
    }
}
