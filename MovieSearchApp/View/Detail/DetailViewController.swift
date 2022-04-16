//
//  DetailViewController.swift
//  MovieSearchApp
//
//  Created by 박근보 on 2022/04/16.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa

final class DetailViewController: BaseViewController {

    private let mainView = DetailView()

    var movieItem: MovieItem?

    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        topViewConfig()
        webViewConfig()
    }

    override func setViewConfig() {
        super.setViewConfig()
    }

    override func navigationItemConfig() {

        mainView.backBarButton.target = self
        mainView.backBarButton.action = #selector(backButtonClicked(sender:))
        navigationItem.leftBarButtonItem = mainView.backBarButton
    }

    private func topViewConfig() {

        guard let movieItem = movieItem else { return }

        if let imageurl = URL(string: movieItem.image) {
            mainView.movieView.posterImageView.kf.setImage(with: imageurl)
        } else {
            mainView.movieView.posterImageView.image = UIImage(systemName: "star")
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
        navigationItem.title = title
        mainView.movieView.titleLabel.text = title
        mainView.movieView.directorLabel.text = "감독: \(director)"
        mainView.movieView.actorLabel.text = "출연: \(actor)"
        mainView.movieView.rateLabel.text = "평점: \(rate)"
    }

    private func webViewConfig() {
        guard let movieItem = movieItem else { return }
        guard let url = URL(string: movieItem.link) else { return }
        let request = URLRequest(url: url)
        mainView.webView.load(request)
    }

    @objc func backButtonClicked(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}
