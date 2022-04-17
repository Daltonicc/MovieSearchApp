//
//  MovieTableViewCell.swift
//  MovieSearchApp
//
//  Created by 박근보 on 2022/04/15.
//

import UIKit
import SnapKit
import Kingfisher

protocol MovieTableViewCellDelegate: AnyObject {
    func didTapFavoriteButton(tag: Int)
}

final class MovieTableViewCell: UITableViewCell {

    let cellView: MovieInfoView = {
        let view = MovieInfoView()
        return view
    }()

    var isFavorite = false

    weak var delegate: MovieTableViewCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setUpView()
        setUpConstraints()

        cellView.favoriteButton.addTarget(self, action: #selector(favoriteButtonTap(sender:)), for: .touchUpInside)
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

    func cellConfig(movieItem: MovieItem, tag: Int) {

        if let imageurl = URL(string: movieItem.image) {
            cellView.posterImageView.kf.setImage(with: imageurl)
        } else {
            cellView.posterImageView.image = UIImage(systemName: "doc.text.image")
        }
        
        let title = movieItem.title
            .replacingOccurrences(of: "<b>", with: "")
            .replacingOccurrences(of: "</b>", with: "")
        var director = movieItem.director
            .replacingOccurrences(of: "|", with: ", ").dropLast()
        var actor = movieItem.actor
            .replacingOccurrences(of: "|", with: ", ").dropLast()
        let rate = movieItem.userRating

        if director.count >= 1 {
            director.removeLast()
        }
        if actor.count >= 1 {
            actor.removeLast()
        }
        isFavorite = movieItem.isFavorite
        
        cellView.favoriteButton.tintColor = movieItem.isFavorite ? .systemYellow : .systemGray3
        cellView.titleLabel.text = title
        cellView.directorLabel.text = "감독: \(director)"
        cellView.actorLabel.text = "출연: \(actor)"
        cellView.rateLabel.text = "평점: \(rate)"
        cellView.favoriteButton.tag = tag
    }

    @objc private func favoriteButtonTap(sender: UIButton) {
        addPressAnimationToButton(scale: 0.85, cellView.favoriteButton) { [weak self] _ in
            guard let self = self else { return }
            self.isFavorite.toggle()
            self.cellView.favoriteButton.tintColor = self.isFavorite ? .systemYellow : .systemGray3
            self.delegate?.didTapFavoriteButton(tag: sender.tag)
        }
    }
}
