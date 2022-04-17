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
    let noResultLabel: UILabel = {
        let label = UILabel()
        label.text = "즐겨찾기한 영화가 없습니다."
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
        addSubview(separateView)
        addSubview(favoriteMovieTableView)
        addSubview(noResultLabel)
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
        noResultLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
