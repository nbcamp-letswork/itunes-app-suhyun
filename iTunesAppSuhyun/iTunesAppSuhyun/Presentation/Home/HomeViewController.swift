//
//  HomeViewController.swift
//  iTunesAppSuhyun
//
//  Created by 이수현 on 5/7/25.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    private let homeView = HomeView()
    private let homeViewModel: HomeViewModel
    private let searchController: SearchController

    typealias DataSource = UICollectionViewDiffableDataSource<HomeSection, HomeItem>
    private var dataSource: DataSource?
    private let disposeBag = DisposeBag()

    init(homeViewModel: HomeViewModel, searchController: SearchController) {
        self.homeViewModel = homeViewModel
        self.searchController = searchController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setDataSource()
        bindView()
        bindViewModel()
        homeViewModel.action.onNext(.fetchMusic)
    }

    private func bindView() {
        homeView.collectionView.rx.itemSelected
            .throttle(.milliseconds(300), scheduler: MainScheduler.asyncInstance)
            .bind {[weak self] indexPath in
                guard let self,
                      let item = self.dataSource?.itemIdentifier(for: indexPath) else {
                    return
                }

                let detailVC = DetailViewController(info: DetailInfo(item.music))
                detailVC.modalPresentationStyle = .fullScreen
                self.present(detailVC, animated: true)
            }.disposed(by: disposeBag)
    }

    private func setDataSource() {
        dataSource = DataSource(
            collectionView: homeView.collectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                switch itemIdentifier {
                case .spring(let item):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeBigBannerCell.id, for: indexPath)
                    (cell as? HomeBigBannerCell)?.configure(with: item)
                    return cell
                case .summer(let item), .autumn(let item):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeVerticalCell.id, for: indexPath)
                    (cell as? HomeVerticalCell)?.configure(with: item)
                    return cell
                case .winter(let item):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeBannerCell.id, for: indexPath)
                    (cell as? HomeBannerCell)?.configure(with: item)
                    return cell
                }
            }
        )

        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: HeaderView.id,
                for: indexPath
            )

            guard let section = HomeSection(rawValue: indexPath.section) else {
                return UICollectionReusableView()
            }

            (headerView as? HeaderView)?.configure(title: section.title, subTitle: section.subTitle)
            return headerView
        }
    }

    private func bindViewModel() {
        Observable.combineLatest(
            homeViewModel.state.springItem,
            homeViewModel.state.summerItem,
            homeViewModel.state.autumnItem,
            homeViewModel.state.winterItem
        )
        .map { [$0, $1, $2, $3] }
        .observe(on: MainScheduler.instance)
        .subscribe(onNext: { [weak self] items in
            var snapShot = NSDiffableDataSourceSnapshot<HomeSection, HomeItem>()

            zip(HomeSection.allCases, items).forEach { section, item in
                snapShot.appendSections([section])
                snapShot.appendItems(item, toSection: section)
            }

            self?.dataSource?.apply(snapShot)
        })
        .disposed(by: disposeBag)

        homeViewModel.state.error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {[weak self] error in
                self?.showErrorAlert(error: error)
            }).disposed(by: disposeBag)
    }
}

private extension HomeViewController {
    func setNavigationBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        title = "Music"
        navigationItem.backButtonTitle = title
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
