//
//  DetailViewController.swift
//  iTunesAppSuhyun
//
//  Created by 이수현 on 5/15/25.
//

import RxCocoa
import RxSwift
import AVFoundation
import AVKit

final class DetailViewController: UIViewController {
    private let detailView: DetailView
    private let disposeBag = DisposeBag()

    init(info: DetailInfo) {
        self.detailView = DetailView(info: info)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        view = detailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        detailView.setPreviewDelegate(self)
        bindView()
    }

    private func bindView() {
        detailView.dismissButton.rx.tap
            .bind {[weak self] in
                self?.dismiss(animated: true)
            }.disposed(by: disposeBag)
    }
}

extension DetailViewController: PreviewViewDelegate {
    func didTapPlayButton(_ previewURLString: String) {
        guard let url = URL(string: previewURLString) else{ return }
        let player = AVPlayer(url: url)
        let playerController = AVPlayerViewController()
        playerController.player = player

        self.present(playerController, animated: true) {
            player.play()
        }
    }
}
