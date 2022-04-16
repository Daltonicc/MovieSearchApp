//
//  FavoriteView.swift
//  MovieSearchApp
//
//  Created by 박근보 on 2022/04/16.
//

import UIKit
import SnapKit

final class FavoriteView: BaseView {

    let separateView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    let favoriteMovieTableView: UITableView = {
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
        addSubview(separateView)
        addSubview(favoriteMovieTableView)
    }

    override func setUpConstraint() {

        separateView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(5)
        }
        favoriteMovieTableView.snp.makeConstraints { make in
            make.top.equalTo(separateView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
        }
    }
}
