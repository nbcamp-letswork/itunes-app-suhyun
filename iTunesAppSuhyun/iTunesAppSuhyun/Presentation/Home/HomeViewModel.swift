//
//  HomeViewModel.swift
//  iTunesAppSuhyun
//
//  Created by 이수현 on 5/8/25.
//

import RxSwift

protocol ViewModelProtocol {
    associatedtype Action
    associatedtype State

    var action: PublishSubject<Action> { get }
    var state: State { get }
}

final class HomeViewModel: ViewModelProtocol {
    private let musicUseCase: MusicUseCaseProtocol
    private let disposeBag = DisposeBag()

    enum Action {
        case fetchMusic
    }

    struct State {
        var springItem = PublishSubject<[HomeItem]>()
        var summerItem = PublishSubject<[HomeItem]>()
        var autumnItem = PublishSubject<[HomeItem]>()
        var winterItem = PublishSubject<[HomeItem]>()
        var error = PublishSubject<AppError>()
    }

    let action = PublishSubject<Action>()
    fileprivate(set) var state = State()

    init(musicUseCase: MusicUseCaseProtocol) {
        self.musicUseCase = musicUseCase
        setBinding()
    }

    private func setBinding() {
        action.subscribe {[weak self] action in
            switch action {
            case .fetchMusic:
                self?.fetchMusic()
            }
        }.disposed(by: disposeBag)
    }

    private func fetchMusic() {
        Task {
            do {
                try await withThrowingTaskGroup(of: (HomeSection, [Music]).self) {[weak self] group in
                    guard let self else { return }

                    HomeSection.allCases.forEach { section in
                        group.addTask {
                            let musics = try await self.musicUseCase.fetchMusic(keyword: section.keyword, limit: section.limit)
                            return (section, musics)
                        }
                    }

                    for try await (section, musics) in group {
                        let items = musics.map { section.createItem(from: $0) }
                        getSubject(for: section).onNext(items)
                    }
                }
            } catch {
                state.error.onNext(error as? AppError ?? AppError.unKnown(error))
            }
        }
    }

    private func getSubject(for section: HomeSection) -> PublishSubject<[HomeItem]> {
        switch section {
        case .spring: return state.springItem
        case .summer: return state.summerItem
        case .autumn: return state.autumnItem
        case .winter: return state.winterItem
        }
    }
}
