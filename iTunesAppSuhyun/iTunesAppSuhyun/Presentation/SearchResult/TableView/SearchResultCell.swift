//
//  SearchResultCell.swift
//  iTunesAppSuhyun
//
//  Created by 이수현 on 5/13/25.
//

import UIKit

final class SearchResultCell: UITableViewCell {
    static let id = "SearchResultCell"
    private let colors: [UIColor] = [
        .systemBlue.withAlphaComponent(0.5),
        .systemGreen.withAlphaComponent(0.5),
        .systemPink.withAlphaComponent(0.5),
        .systemMint.withAlphaComponent(0.5),
        .systemOrange.withAlphaComponent(0.5)
    ]

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 1
        return label
    }()

    private let genreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black.withAlphaComponent(0.5)
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.numberOfLines = 1
        return label
    }()

    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 1
        return label
    }()

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0))
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        titleLabel.text = nil
        genreLabel.text = nil
        releaseDateLabel.text = nil
        posterImageView.image = nil
    }

    func configure(with searchResult: SearchResult, index: Int) {
        titleLabel.text = searchResult.mediaInfo.title
        genreLabel.text = searchResult.mediaInfo.genre
        releaseDateLabel.text = searchResult.mediaInfo.releaseDate.toReleaseDateFormmat()
        posterImageView.setImage(with: searchResult.mediaInfo.imageURL, toSize: 600)
        self.contentView.backgroundColor = colors[index % colors.count]
    }
}

private extension SearchResultCell {

    func configure() {
        setLayout()
        setHierarchy()
        setConstraints()
    }

    func setLayout() {
        self.contentView.layer.cornerRadius = 10
        self.contentView.clipsToBounds = true
    }

    func setHierarchy() {
        self.contentView.addSubviews(
            titleLabel,
            genreLabel,
            releaseDateLabel,
            posterImageView
        )
    }

    func setConstraints() {
        genreLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(12)
            make.trailing.equalTo(releaseDateLabel.snp.leading)
        }

        releaseDateLabel.snp.makeConstraints { make in
            make.top.equalTo(genreLabel)
            make.trailing.equalToSuperview().inset(8)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(genreLabel.snp.bottom).offset(12)
            make.directionalHorizontalEdges.equalToSuperview().inset(12)
        }

        posterImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.directionalHorizontalEdges.bottom.equalToSuperview().inset(12)
        }
    }
}

