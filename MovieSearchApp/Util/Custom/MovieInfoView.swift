//
//  MovieInfoView.swift
//  MovieSearchApp
//
//  Created by 박근보 on 2022/04/15.
//

import UIKit
import SnapKit

final class MovieInfoView: BaseView {

    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(systemName: "star")
        return imageView
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    let directorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    let actorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    let rateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    let favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star.fill"), for: .normal)
        button.tintColor = .systemGray3
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func setUpView() {

        addSubview(posterImageView)
        addSubview(titleLabel)
        addSubview(directorLabel)
        addSubview(actorLabel)
        addSubview(rateLabel)
        addSubview(favoriteButton)
    }

    override func setUpConstraint() {

        posterImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.leading.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(5)
            make.width.equalTo(60)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.leading.equalTo(posterImageView.snp.trailing).offset(10)
            make.trailing.equalTo(favoriteButton.snp.leading).inset(-5)
        }
        directorLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(posterImageView.snp.trailing).offset(10)
            make.trailing.equalTo(favoriteButton.snp.leading).inset(-5)
        }
        actorLabel.snp.makeConstraints { make in
            make.top.equalTo(directorLabel.snp.bottom).offset(10)
            make.leading.equalTo(posterImageView.snp.trailing).offset(10)
            make.trailing.equalTo(favoriteButton.snp.leading).inset(-5)
        }
        rateLabel.snp.makeConstraints { make in
            make.top.equalTo(actorLabel.snp.bottom).offset(10)
            make.leading.equalTo(posterImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
        }
        favoriteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(10)
            make.width.height.equalTo(20)
        }

    }
}
