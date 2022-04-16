//
//  FavoriteViewController.swift
//  MovieSearchApp
//
//  Created by 박근보 on 2022/04/16.
//

import UIKit
import RxSwift
import RxCocoa

final class FavoriteViewController: BaseViewController {

    private lazy var input = FavoriteViewModel.Input(
        requestFavoriteMovieListEvent: requestFavoriteMovieListEvent.asSignal(),
        pressFavoriteButton: pressFavoriteButton.asSignal(),
        pressMovieItem: pressMovieItem.asSignal()
        )
    private lazy var output = viewModel.transform(input: input)

    private let mainView = FavoriteView()
    private var viewModel = FavoriteViewModel()
    private let disposeBag = DisposeBag()

    private let requestFavoriteMovieListEvent = PublishRelay<Void>()
    private let pressFavoriteButton = PublishRelay<Int>()
    private let pressMovieItem = PublishRelay<Int>()

    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        requestFavoriteMovieListEvent.accept(())
    }

    override func setViewConfig() {
        super.setViewConfig()

        mainView.favoriteMovieTableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        mainView.favoriteMovieTableView.rowHeight = 110
    }

    override func navigationItemConfig() {
        navigationItem.title = "즐겨찾기 목록"
        mainView.backBarButton.target = self
        mainView.backBarButton.action = #selector(backButtonClicked(sender:))
        navigationItem.leftBarButtonItem = mainView.backBarButton
    }

    override func bind() {

        output.didLoadFavoriteMovieList
            .drive(mainView.favoriteMovieTableView.rx.items(cellIdentifier: MovieTableViewCell.identifier, cellType: MovieTableViewCell.self)) { (row, element, cell) in
                cell.cellConfig(movieItem: element, tag: row)
            }
            .disposed(by: disposeBag)
    }

    @objc func backButtonClicked(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}
