//
//  Int+Extensions.swift
//  iTunesAppSuhyun
//
//  Created by 이수현 on 5/9/25.
//

import Foundation

extension Int {
    func toReplayTime() -> String {
        var replayTime = ""
        if self / 60 != 0 { replayTime += "\(self / 60)분" }
        if self % 60 != 0 { replayTime += "\(self % 60)초" }
        return replayTime
    }

    func toKRW() -> String {
        return self.formatted(.currency(code: "KRW"))
    }
}
