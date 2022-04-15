//
//  MovieSearchViewController.swift
//  MovieSearchApp
//
//  Created by 박근보 on 2022/04/14.
//

import UIKit
import RxSwift
import RxCocoa

final class MovieSearchViewController: BaseViewController {

    private lazy var input = MovieSearchViewModel.Input(
        requestMovieListEvent: requestMovieListEvent.asSignal(),
        pressFavoriteButtonList: mainView.favoriteButtonListbarButton.rx.tap.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)

    private let mainView = MovieSearchView()
    private var viewModel = MovieSearchViewModel()
    private let disposeBag = DisposeBag()

    private let requestMovieListEvent = PublishRelay<String>()
    private let pressFavoriteButtonList = PublishRelay<Void>()

    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func setViewConfig() {
        super.setViewConfig()

        mainView.movieTableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        mainView.movieTableView.keyboardDismissMode = .onDrag
        mainView.movieTableView.rowHeight = 110

        mainView.searchBar.delegate = self
        mainView.searchBar.searchTextField.delegate = self
    }

    override func navigationItemConfig() {

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: mainView.titleView)
        navigationItem.rightBarButtonItem = mainView.favoriteButtonListbarButton
    }

    override func bind() {

        output.didLoadMovieData
            .drive(mainView.movieTableView.rx.items(cellIdentifier: MovieTableViewCell.identifier, cellType: MovieTableViewCell.self)) { (row, element, cell) in
                cell.cellConfig(movieItem: element)
            }
            .disposed(by: disposeBag)
    }
}

extension MovieSearchViewController: UISearchBarDelegate, UISearchTextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        guard let query = mainView.searchBar.searchTextField.text else { return true }
        requestMovieListEvent.accept(query)
        return true
    }
}
