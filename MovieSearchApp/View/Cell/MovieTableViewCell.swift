//
//  MovieTableViewCell.swift
//  MovieSearchApp
//
//  Created by 박근보 on 2022/04/15.
//

import UIKit
import SnapKit
import Kingfisher

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

    func cellConfig(movieItem: MovieItem) {

        if let imageurl = URL(string: movieItem.image) {
            cellView.posterImageView.kf.setImage(with: imageurl)
        } else {
            cellView.posterImageView.image = UIImage(systemName: "star")
        }
        
        let title = movieItem.title
            .replacingOccurrences(of: "<b>", with: "")
            .replacingOccurrences(of: "</b>", with: "")
        var director = movieItem.director
            .replacingOccurrences(of: "|", with: ", ")
        var actor = movieItem.actor
            .replacingOccurrences(of: "|", with: ", ")
        let rate = movieItem.userRating

        if director.count >= 1 {
            director.removeLast()
            director.removeLast()
        }
        if actor.count >= 1 {
            actor.removeLast()
            actor.removeLast()
        }
        cellView.titleLabel.text = title
        cellView.directorLabel.text = "감독: \(director)"
        cellView.actorLabel.text = "출연: \(actor)"
        cellView.rateLabel.text = "평점: \(rate)"
    }
}
