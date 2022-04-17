//
//  MovieSearchView.swift
//  MovieSearchApp
//
//  Created by 박근보 on 2022/04/15.
//

import UIKit
import SnapKit

final class MovieSearchView: BaseView {

    let titleView: UIView = {
        let view = UIView()
        return view
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "네이버 영화 검색"
        label.font = .boldSystemFont(ofSize: 25)
        return label
    }()
    let favoriteButtonListBarButton: UIButton = {
        let button = UIButton()
        let viewFrame = CGRect(x: 0, y: 0, width: 90, height: 30)
        let view = FavoriteListButtonView(frame: viewFrame)
        view.isUserInteractionEnabled = false
        button.frame = CGRect(x: 0, y: 0, width: 90, height: 30)
        button.addSubview(view)
        return button
    }()
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "검색어를 입력해주세요"
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    let movieTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    let noResultLabel: UILabel = {
        let label = UILabel()
        label.text = "검색 결과가 없습니다."
        label.font = .systemFont(ofSize: 30)
        label.textColor = .systemGray4
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func setUpView() {

        addSubview(titleView)
        addSubview(searchBar)
        addSubview(movieTableView)
        addSubview(noResultLabel)

        titleView.addSubview(titleLabel)
    }

    override func setUpConstraint() {

        searchBar.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(0)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        movieTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview().inset(10)
        }
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        noResultLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
