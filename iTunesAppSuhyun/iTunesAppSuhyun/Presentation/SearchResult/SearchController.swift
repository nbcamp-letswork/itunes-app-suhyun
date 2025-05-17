//
//  SearchController.swift
//  iTunesAppSuhyun
//
//  Created by 이수현 on 5/12/25.
//

import UIKit
import RxSwift
import RxCocoa
import os

final class SearchController: UISearchController {
    private let searchResultView = SearchResultView()
    private let viewModel: SearchResultViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: SearchResultViewModel) {
        self.viewModel = viewModel
        super.init(searchResultsController: nil)

        configure()
    }

    @available(*, unavailable, message: "storyboard is not supported.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    override func loadView() {
        view = searchResultView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindView()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.searchResultView.alpha = 1
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animate(withDuration: 0.2) {
            self.searchResultView.alpha = 0
            self.searchBar.showsScopeBar = false
        }
    }

    private func bindView() {
        let tapGesture = searchResultView.titleLabelTapGesture()

        tapGesture.rx.event
            .bind { [weak self] _ in
                guard let self else { return }
                self.dismiss(animated: true)
            }.disposed(by: disposeBag)


        searchBar.rx.text.orEmpty
            .filter { !$0.isEmpty }
            .do {[weak self] text in
                self?.searchResultView.configure(title: text)
            }
            .distinctUntilChanged({ $0 == $1 })
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .withLatestFrom(searchBar.rx.selectedScopeButtonIndex) { text, index in
                guard let type = SearchType(rawValue: index) else { return (text, .movie) }
                return (text, type)
            }
            .bind { [weak self] text, type in
                self?.viewModel.action
                    .onNext(.search(keyword: text, type: type))
            }.disposed(by: disposeBag)

        searchBar.rx.selectedScopeButtonIndex
            .bind {[weak self] selectedIndex in
                guard let type = SearchType(rawValue: selectedIndex) else { return }
                self?.viewModel.action
                    .onNext(.changedType(type: type))
            }.disposed(by: disposeBag)

        searchResultView.tableView.rx.itemSelected
            .withLatestFrom(
                Observable.combineLatest(
                    viewModel.state.moiveResult,
                    viewModel.state.podcastResult,
                    resultSelector: { movies, podcasts in
                        return (movies: movies, podcasts: podcasts)
                    })
                , resultSelector: { return ($0, $1) }
            )
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind { [weak self] indexPath, items in
                guard let self else { return }
                var detailVC: DetailViewController?
                switch SearchType(rawValue: searchBar.selectedScopeButtonIndex) {
                case .movie:
                    let item = items.movies[indexPath.row]
                    detailVC = DetailViewController(info: DetailInfo(item))
                case .podcast:
                    let item = items.podcasts[indexPath.row]
                    detailVC = DetailViewController(info: DetailInfo(item))
                case .none:
                    return
                }
                guard let detailVC else { return }
                detailVC.modalPresentationStyle = .fullScreen
                self.present(detailVC, animated: true)
            }.disposed(by: disposeBag)

        self.rx.willPresent
            .bind {[weak self] in
                self?.searchBar.showsScopeBar = true
            }.disposed(by: disposeBag)
    }

    private func bindViewModel() {
        viewModel.state.searchResult
            .observe(on: MainScheduler.instance)
            .bind(to: searchResultView.tableView.rx.items) { tableView, row, item in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.id) as? SearchResultCell else {
                    return UITableViewCell()
                }
                cell.configure(with: item, index: row)

                return cell
            }.disposed(by: disposeBag)

        viewModel.state.error
            .observe(on: MainScheduler.instance)
            .subscribe {[weak self] error in
                os_log(.error, "%@", error.debugDescription)
                self?.showErrorAlert(error: error)
            }.disposed(by: disposeBag)
    }
}

private extension SearchController {
    func configure() {
        self.obscuresBackgroundDuringPresentation = true

        let allCasesTitle = SearchType.allCases.map{ $0.title }
        self.searchBar.placeholder = allCasesTitle.joined(separator: ", ")
        self.searchBar.scopeButtonTitles = allCasesTitle
    }
}
