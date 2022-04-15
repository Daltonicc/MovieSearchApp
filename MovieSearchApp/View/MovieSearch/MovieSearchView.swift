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
    let favoriteButtonListbarButton: UIBarButtonItem = {
        let barbutton = UIBarButtonItem()
        let view = FavoriteListButtonView()
        barbutton.customView = view
        return barbutton
    }()
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = ""
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    let movieTableView: UITableView = {
        let tableView = UITableView()
        return tableView
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

        titleView.addSubview(titleLabel)
    }

    override func setUpConstraint() {

        searchBar.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(0)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        movieTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview().inset(10)
        }

        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
