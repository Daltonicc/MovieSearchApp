//
//  FavoriteListButtonView.swift
//  MovieSearchApp
//
//  Created by 박근보 on 2022/04/15.
//

import UIKit
import SnapKit

final class FavoriteListButtonView: BaseView {

    let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = .systemYellow
        return imageView
    }()
    let favoriteLabel: UILabel = {
        let label = UILabel()
        label.text = "즐겨찾기"
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func setUpView() {

        self.layer.borderColor = UIColor.favoirteListButtonColor.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5

        addSubview(starImageView)
        addSubview(favoriteLabel)
    }

    override func setUpConstraint() {

        starImageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(5)
        }
        favoriteLabel.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview().inset(5)
            make.leading.equalTo(starImageView.snp.trailing)
        }
    }
}
