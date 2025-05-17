//
//  DetailInfoView.swift
//  iTunesAppSuhyun
//
//  Created by 이수현 on 5/15/25.
//

import UIKit

final class DetailInfoView: UIStackView {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()

    private let verticalInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()

    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 1
        return label
    }()

    private let etcInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()

    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        return label
    }()

    private let replayTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.numberOfLines = 1
        label.textAlignment = .right
        return label
    }()

    init(info: DetailInfo) {
        super.init(frame: .zero)
        configure()
        configure(info: info)
    }

    @available(*, unavailable, message: "storyboard is not supported.")
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(info: DetailInfo) {
        titleLabel.text = info.mediaInfo.title
        imageView.setImage(with: info.mediaInfo.imageURL, toSize: 600)
        subTitleLabel.text = info.subTitle
        releaseDateLabel.text = info.mediaInfo.releaseDate.toReleaseDateFormmat()
        replayTimeLabel.text = info.replayTime
    }
}

private extension DetailInfoView {

    func configure() {
        setLayout()
        setHierarchy()
        setConstraints()
    }

    func setLayout() {
        self.axis = .horizontal
        self.spacing = 8
        self.backgroundColor = .white
    }

    func setHierarchy() {
        self.addArrangedSubviews(imageView, verticalInfoStackView)
        verticalInfoStackView.addArrangedSubviews(titleLabel, subTitleLabel, etcInfoStackView)
        etcInfoStackView.addArrangedSubviews(releaseDateLabel, replayTimeLabel)
    }

    func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.size.equalTo(80)
        }
    }
}

