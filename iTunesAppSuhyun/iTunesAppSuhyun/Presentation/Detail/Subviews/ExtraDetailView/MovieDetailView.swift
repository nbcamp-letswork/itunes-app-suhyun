//
//  MovieDetailView.swift
//  iTunesAppSuhyun
//
//  Created by 이수현 on 5/16/25.
//

import UIKit

final class MovieDetailView: UIStackView, PreviewProvider {
    let previewView: PreviewView

    private let priceStacKView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        return stackView
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "가격"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()

    private let priceInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()

    private let descriptionStacKView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "줄거리"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()

    private let descriptionInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()

    init(info: MovieExtraInfo) {
        self.previewView = PreviewView(info: info.previewInfo)
        super.init(frame: .zero)

        configure()
        configure(with: info)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(with info: MovieExtraInfo) {
        self.priceInfoLabel.text = Int(info.price).toKRW()
        self.descriptionInfoLabel.text = info.description
    }
}

private extension MovieDetailView {

    func configure() {
        setLayout()
        setHierarchy()
    }

    func setLayout() {
        self.axis = .vertical
        self.spacing = 20
    }

    func setHierarchy() {
        self.addArrangedSubviews(priceStacKView, descriptionStacKView, previewView)
        priceStacKView.addArrangedSubviews(priceLabel, priceInfoLabel)
        descriptionStacKView.addArrangedSubviews(descriptionLabel, descriptionInfoLabel)
    }
}

