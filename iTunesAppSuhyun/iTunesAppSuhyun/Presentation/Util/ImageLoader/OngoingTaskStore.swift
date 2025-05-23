//
//  OngoingTaskStore.swift
//  iTunesAppSuhyun
//
//  Created by 이수현 on 5/8/25.
//

import UIKit

actor OngoingTaskStore {
    private var tasks: [String: Task<UIImage?, Never>] = [:]

    func getTask(for key: String) -> Task<UIImage?, Never>? {
        return tasks[key]
    }

    func setTask(_ task: Task<UIImage?, Never>, for key: String) {
        tasks[key] = task
    }

    func removeTask(for key: String) {
        tasks[key] = nil
    }
}
