//
//  Date+ISO8601Parsing.swift
//  iTunesAppSuhyun
//
//  Created by 이수현 on 5/15/25.
//

import Foundation

extension Date {
    init?(iso8601String: String) {
        let dateFormatter = ISO8601DateFormatter()
        guard let date = dateFormatter.date(from: iso8601String) else { return nil }
        self = date
    }
}
