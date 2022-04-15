//
//  MovieTableViewCell.swift
//  MovieSearchApp
//
//  Created by 박근보 on 2022/04/15.
//

import UIKit
import SnapKit

final class MovieTableViewCell: UITableViewCell {

    let cellView: MovieInfoView = {
        let view = MovieInfoView()
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setUpView()
        setUpConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setUpView() {
        
        contentView.addSubview(cellView)
    }

    private func setUpConstraints() {

        cellView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
