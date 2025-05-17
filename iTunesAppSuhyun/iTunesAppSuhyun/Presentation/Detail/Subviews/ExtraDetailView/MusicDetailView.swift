//
//  MusicDetailView.swift
//  iTunesAppSuhyun
//
//  Created by 이수현 on 5/17/25.
//

import UIKit

final class MusicDetailView: UIStackView, PreviewProvider {
    let previewView: PreviewView

    init(info: MusicExtraInfo) {
        self.previewView = PreviewView(info: info.previewInfo)
        super.init(frame: .zero)
        configure()
    }

    @available(*, unavailable, message: "storyboard is not supported.")
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

}

private extension MusicDetailView {

    func configure() {
        setHierarchy()
        setConstraints()
    }

    func setHierarchy() {
        self.addArrangedSubview(previewView)
    }

    func setConstraints() {
        previewView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

