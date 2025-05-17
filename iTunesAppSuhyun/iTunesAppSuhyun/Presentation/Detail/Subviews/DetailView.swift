//
//  DetailView.swift
//  iTunesAppSuhyun
//
//  Created by 이수현 on 5/15/25.
//

import UIKit

final class DetailView: UIView {

    private let pageTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 1
        label.backgroundColor = .white
        label.textAlignment = .center
        return label
    }()

    let dismissButton: UIButton = {
        var config = UIButton.Configuration.plain()
        var imageConfig = UIImage.SymbolConfiguration(pointSize: 16)
        config.preferredSymbolConfigurationForImage = imageConfig
        config.image = .init(systemName: "xmark")
        config.baseForegroundColor = .white
        config.contentInsets = .zero

        let button = UIButton()
        button.configuration = config
        button.backgroundColor = .systemGray
        button.layer.cornerRadius = 18
        button.clipsToBounds = true
        return button
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private let contentView = UIView()

    private let posterView: PosterView
    private let detailInfoView: DetailInfoView
    private var extraInfoView: UIStackView?

    init(info: DetailInfo) {
        self.pageTitleLabel.text = info.type.media
        self.posterView = PosterView(info: info)
        self.detailInfoView = DetailInfoView(info: info)

        if let extraInfo = info.extraInfo as? MovieExtraInfo {
            extraInfoView = MovieDetailView(info: extraInfo)
        } else if let extraInfo = info.extraInfo as? MusicExtraInfo {
            extraInfoView = MusicDetailView(info: extraInfo)
        }

        super.init(frame: .zero)
        configure()
    }

    @available(*, unavailable, message: "storyboard is not supported.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    func setPreviewDelegate(_ delegate: PreviewViewDelegate) {
        (extraInfoView as? PreviewProvider)?.previewView.setPreviewDeleate(delegate)
    }
}

private extension DetailView {

    func configure() {
        setLayout()
        setHierarchy()
        setConstraints()
    }

    func setLayout() {
        self.backgroundColor = .white
    }

    func setHierarchy() {
        self.addSubviews(pageTitleLabel, scrollView, dismissButton)
        scrollView.addSubview(contentView)
        contentView.addSubviews(posterView, detailInfoView)

        if let extraInfoView {
            contentView.addSubview(extraInfoView)
        }
    }

    func setConstraints() {
        pageTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.directionalHorizontalEdges.equalToSuperview()
            make.height.equalTo(60)
        }

        dismissButton.snp.makeConstraints { make in
            make.top.equalTo(pageTitleLabel.snp.bottom).offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.size.equalTo(36)
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(pageTitleLabel.snp.bottom)
            make.bottom.directionalHorizontalEdges.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        posterView.snp.makeConstraints { make in
            make.top.directionalHorizontalEdges.equalToSuperview()
        }

        if let extraInfoView {
            detailInfoView.snp.makeConstraints { make in
                make.top.equalTo(posterView.snp.bottom).offset(16)
                make.directionalHorizontalEdges.equalToSuperview().inset(16)
            }

            extraInfoView.snp.makeConstraints { make in
                make.top.equalTo(detailInfoView.snp.bottom).offset(20)
                make.directionalHorizontalEdges.equalToSuperview().inset(16)
                make.bottom.equalToSuperview()
            }
        } else {
            detailInfoView.snp.makeConstraints { make in
                make.top.equalTo(posterView.snp.bottom).offset(16)
                make.directionalHorizontalEdges.equalToSuperview().inset(16)
                make.bottom.lessThanOrEqualToSuperview()
            }
        }
    }
}
