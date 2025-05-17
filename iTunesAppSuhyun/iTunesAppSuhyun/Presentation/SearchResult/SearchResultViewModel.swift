//
//  SearchResultViewModel.swift
//  iTunesAppSuhyun
//
//  Created by 이수현 on 5/13/25.
//

import RxSwift

final class SearchResultViewModel: ViewModelProtocol {

    enum Action {
        case search(keyword: String, type: SearchType)
        case changedType(type: SearchType)
    }

    struct State {
        let moiveResult = PublishSubject<[Movie]>()
        let podcastResult = PublishSubject<[Podcast]>()
        let searchResult = PublishSubject<[SearchResult]>()
        let error = PublishSubject<AppError>()
    }

    private let movieUseCase: MovieUseCaseProtocol
    private let podcastUseCase: PodcastUseCaseProtocol

    private var movieResult = [SearchResult]()
    private var podcastResult = [SearchResult]()

    private let disposeBag = DisposeBag()

    let action = PublishSubject<Action>()
    fileprivate(set) var state: State = State()

    init(
        movieUseCase: MovieUseCaseProtocol,
        podcastUseCase: PodcastUseCaseProtocol
    ) {
        self.movieUseCase = movieUseCase
        self.podcastUseCase = podcastUseCase

        bindAction()
    }

    private func bindAction() {
        action
            .subscribe {[weak self] action in
                guard let self else { return }
                switch action {
                case .search(let keyword, let type):
                    self.fetchData(keyword: keyword, type: type)
                case .changedType(let type):
                    self.changedType(type: type)
                }
            }.disposed(by: disposeBag)
    }

    private func fetchData(keyword: String, type: SearchType) {
        Task {
            async let movieData = fetchMovie(keyword: keyword)
            async let podcastData = fetchPodcast(keyword: keyword)

            do {
                (movieResult, podcastResult) = try await (movieData, podcastData)
                changedType(type: type)
            } catch {
                handleError(error)
            }
        }
    }

    private func fetchMovie(keyword: String) async throws -> [SearchResult] {
        let result =  try await movieUseCase.fetchMovie(keyword: keyword)
        state.moiveResult.onNext(result)
        return result.map{ SearchResult(mediaInfo: $0.mediaInfo) }

    }

    private func fetchPodcast(keyword: String) async throws -> [SearchResult] {
        let result = try await podcastUseCase.fetchPodcast(keyword: keyword)
        state.podcastResult.onNext(result)
        return result.map{ SearchResult(mediaInfo: $0.mediaInfo) }
    }

    private func changedType(type: SearchType) {
        switch type {
        case .movie:
            state.searchResult.onNext(movieResult)
        case .podcast:
            state.searchResult.onNext(podcastResult)
        }
    }

    private func handleError(_ error: Error) {
        if let error = error as? AppError {
            state.error.onNext(error)
        } else {
            state.error.onNext(AppError.unKnown(error))
        }
    }
}
