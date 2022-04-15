//
//  MovieSearchView.swift
//  MovieSearchApp
//
//  Created by 박근보 on 2022/04/15.
//

import UIKit

final class MovieSearchView: BaseView {

    let favoriteButtonListButton: UIButton = {
        let button = UIButton()
        let view = FavoriteListButtonView()
        button.addSubview(view)
        return button
    }()
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
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

    }

    override func setUpConstraint() {

    }
}
