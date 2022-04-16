//
//  MovieSearchViewController.swift
//  MovieSearchApp
//
//  Created by 박근보 on 2022/04/14.
//

import UIKit
import RxSwift
import RxCocoa
import Toast

final class MovieSearchViewController: BaseViewController {

    private lazy var input = MovieSearchViewModel.Input(
        requestMovieListEvent: requestMovieListEvent.asSignal(),
        requestNextPageMovieListEvent: requestNextPageMovieListEvent.asSignal(),
        pressFavoriteButtonList: pressFavoriteButtonList.asSignal(),
        pressFavoriteButton: pressFavoriteButton.asSignal(),
        pressMovieItem: pressMovieItem.asSignal()
        )
    private lazy var output = viewModel.transform(input: input)

    private let mainView = MovieSearchView()
    private var viewModel = MovieSearchViewModel()
    private let disposeBag = DisposeBag()

    private let requestMovieListEvent = PublishRelay<String>()
    private let requestNextPageMovieListEvent = PublishRelay<String>()
    private let pressFavoriteButtonList = PublishRelay<Void>()
    private let pressFavoriteButton = PublishRelay<Bool>()
    private let pressMovieItem = PublishRelay<Int>()

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

        mainView.favoriteButtonListBarButton.addTarget(self, action: #selector(favoriteListBarButtonTap(sender:)), for: .touchUpInside)
    }

    override func navigationItemConfig() {

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: mainView.titleView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: mainView.favoriteButtonListBarButton)
    }

    override func bind() {

        // Fetch 영화 데이터
        output.didLoadMovieData
            .drive(mainView.movieTableView.rx.items(cellIdentifier: MovieTableViewCell.identifier, cellType: MovieTableViewCell.self)) { (row, element, cell) in
                cell.cellConfig(movieItem: element)
                self.checkLastElement(row: row, element: self.viewModel.totalMovieData)
            }
            .disposed(by: disposeBag)

        // Favorite 뷰 이동
        output.didLoadFavoirteView
            .emit { [weak self] _ in
                guard let self = self else { return }
                self.showFavoriteView()
            }
            .disposed(by: disposeBag)

        // 네트워크 오류 발생시
        output.failToastAction
            .emit { [weak self] errorMessage in
                guard let self = self else { return }
                self.mainView.makeToast(errorMessage)
            }
            .disposed(by: disposeBag)

        // 검색결과 없을시
        output.noResultAction
            .drive { [weak self] bool in
                guard let self = self else { return }
                self.mainView.noResultLabel.isHidden = bool
            }
            .disposed(by: disposeBag)

        // 셀 클릭 후 이동
        output.didPressMovieItem
            .emit { [weak self] item in
                guard let self = self else { return }
                self.showDetailView()
            }
            .disposed(by: disposeBag)

        // 셀 클릭시 input으로 row값 넘겨줌
        mainView.movieTableView.rx.itemSelected
            .bind { [weak self] indexPath in
                guard let self = self else { return }
                self.pressMovieItem.accept(indexPath.row)
            }
            .disposed(by: disposeBag)
    }

    // showFavoriteView
    private func showFavoriteView() {
        let favoriteView = FavoriteViewController()
        favoriteView.modalTransitionStyle = .coverVertical
        favoriteView.modalPresentationStyle = .fullScreen
        self.present(favoriteView, animated: true, completion: nil)
    }

    // showDetailView
    private func showDetailView() {
        let detailView = DetailViewController()
        detailView.modalTransitionStyle = .coverVertical
        detailView.modalPresentationStyle = .fullScreen
        self.present(detailView, animated: true, completion: nil)
    }

    // Pagination
    private func checkLastElement(row: Int, element: [MovieItem]) {
        if row == element.count - 1 {
            guard let query = mainView.searchBar.searchTextField.text else { return }
            requestNextPageMovieListEvent.accept(query)
        }
    }

    @objc private func favoriteListBarButtonTap(sender: UIButton) {
        addPressAnimationToButton(scale: 0.95, mainView.favoriteButtonListBarButton) { [weak self] _ in
            self?.pressFavoriteButtonList.accept(())
        }
    }
}

extension MovieSearchViewController: UISearchBarDelegate, UISearchTextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        guard let query = mainView.searchBar.searchTextField.text else { return true }
        requestMovieListEvent.accept(query)
        return true
    }
}
