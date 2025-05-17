//
//  PreviewView.swift
//  iTunesAppSuhyun
//
//  Created by 이수현 on 5/16/25.
//

import UIKit
import RxSwift
import RxCocoa

// Preview 객체를 존재하는 View에서 채택 (MovieDetailView, PodcastDetailView)
protocol PreviewProvider {
    var previewView: PreviewView { get }
}

// Preview 재생 딜리게이트
protocol PreviewViewDelegate: AnyObject {
    func didTapPlayButton(_ previewURLString: String)
}

final class PreviewView: UIStackView {
    private let previewURLString: String
    private let disposeBag = DisposeBag()
    var delegate: PreviewViewDelegate?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "미리보기"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()

    private let playView = UIView()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()

    private let playButton: UIButton = {
        var config = UIButton.Configuration.plain()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24)
        config.image = .init(systemName: "play.fill")
        config.baseForegroundColor = .white
        config.preferredSymbolConfigurationForImage = imageConfig

        let button = UIButton()
        button.configuration = config
        button.backgroundColor = .black
        button.layer.cornerRadius = 22
        button.clipsToBounds = true
        button.isUserInteractionEnabled = true
        return button
    }()

    init(info: PreviewInfo) {
        self.previewURLString = info.previewURL
        super.init(frame: .zero)
        configure()
        configure(with: info.thumbnailImageURL)
    }
    
    @available(*, unavailable, message: "storyboard is not supported.")
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with imageURL: String) {
        imageView.setImage(with: imageURL, toSize: 600)
    }

    func setPreviewDeleate(_ delegate: PreviewViewDelegate) {
        self.delegate = delegate
    }
}
private extension PreviewView {

    func configure() {
        setLayout()
        setHierarchy()
        setConstraints()
        setBinding()
    }

    func setLayout() {
        self.axis = .vertical
        self.spacing = 8
    }

    func setHierarchy() {
        self.addArrangedSubviews(titleLabel, playView)
        playView.addSubviews(imageView, playButton)
    }

    func setConstraints() {
        playButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(44)
        }

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(150)
        }
    }

    func setBinding() {
        playButton.rx.tap
            .bind {[weak self] _ in
                guard let self else { return }
                self.delegate?.didTapPlayButton(previewURLString)
            }.disposed(by: disposeBag)
    }
}

