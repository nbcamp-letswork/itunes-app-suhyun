//
//  SearchResultView.swift
//  iTunesAppSuhyun
//
//  Created by 이수현 on 5/13/25.
//

import UIKit

final class SearchResultView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.numberOfLines = 1
        label.isUserInteractionEnabled = true
        return label
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UIScreen.main.bounds.width * 1.5
        tableView.sectionHeaderHeight = 60
        tableView.keyboardDismissMode = .onDrag
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.id)
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable, message: "storyboard is not supported.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    func configure(title: String) {
        titleLabel.text = title
    }

    func titleLabelTapGesture() -> UITapGestureRecognizer {
        let tapGesture = UITapGestureRecognizer()
        titleLabel.addGestureRecognizer(tapGesture)
        return tapGesture
    }

}
private extension SearchResultView {

    func configure() {
        setLayout()
        setHierarchy()
        setConstraints()
    }

    func setLayout() {
        self.backgroundColor = .white
    }

    func setHierarchy() {
        addSubviews(titleLabel, tableView)
    }

    func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.equalToSuperview().inset(12)
            make.trailing.lessThanOrEqualToSuperview()
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.bottom.equalToSuperview()
            make.directionalHorizontalEdges.equalToSuperview().inset(12)
        }
    }
}
