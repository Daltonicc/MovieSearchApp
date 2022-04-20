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
        requestRemoveFavoriteEvent: requestRemoveFavoriteEvent.asSignal(),
        pressFavoriteButton: pressFavoriteButton.asSignal(),
        pressMovieItem: pressMovieItem.asSignal()
        )
    private lazy var output = viewModel.transform(input: input)

    private let mainView = FavoriteView()
    private var viewModel = FavoriteViewModel()
    private let disposeBag = DisposeBag()

    private let requestFavoriteMovieListEvent = PublishRelay<Void>()
    private let requestRemoveFavoriteEvent = PublishRelay<Int>()
    private let pressFavoriteButton = PublishRelay<Int>()
    private let pressMovieItem = PublishRelay<Int>()

    override func loadView() {
        self.view = mainView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestFavoriteMovieListEvent.accept(())
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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

        // 즐겨찾기 목록 호출
        output.didLoadFavoriteMovieList
            .drive(mainView.favoriteMovieTableView.rx.items(cellIdentifier: MovieTableViewCell.identifier, cellType: MovieTableViewCell.self)) { (row, element, cell) in
                cell.delegate = self
                cell.cellConfig(movieItem: element, tag: row)
            }
            .disposed(by: disposeBag)

        // 즐겨찾기 목록 비었을 때
        output.noResultAction
            .drive { [weak self] bool in
                guard let self = self else { return }
                self.mainView.noResultLabel.isHidden = bool
            }
            .disposed(by: disposeBag)

        // 셀 클릭하고 이벤트 받은 뒤 이벤트.
        output.didPressMovieItem
            .emit { [weak self] item in
                guard let self = self else { return }
                self.showDetailView(item: item)
            }
            .disposed(by: disposeBag)

        // 즐겨찾기 버튼 눌렀을 때
        output.didPressFavoriteButton
            .emit { [weak self] row in
                guard let self = self else { return }
                self.removeAlert(row: row)
            }
            .disposed(by: disposeBag)

        // 셀 클릭했을 때
        mainView.favoriteMovieTableView.rx.itemSelected
            .bind { [weak self] indexPath in
                guard let self = self else { return }
                self.pressMovieItem.accept(indexPath.row)
            }
            .disposed(by: disposeBag)
    }

    private func showDetailView(item: MovieItem) {
        let detailView = DetailViewController()
        detailView.modalPresentationStyle = .fullScreen
        detailView.movieItem = item
        navigationController?.pushViewController(detailView, animated: true)
    }

    private func removeAlert(row: Int) {
        let alert = UIAlertController(title: "정말 즐겨찾기에서 삭제하시겠습니까?", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel) { [weak self] action in
            self?.viewModel.favoriteMovieData[row].isFavorite.toggle()
            self?.requestFavoriteMovieListEvent.accept(())
        }
        let ok = UIAlertAction(title: "확인", style: .default) { [weak self] action in
            self?.requestRemoveFavoriteEvent.accept(row)
        }
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }

    @objc func backButtonClicked(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}

extension FavoriteViewController: MovieTableViewCellDelegate {
    func didTapFavoriteButton(tag: Int) {
        pressFavoriteButton.accept(tag)
    }
}
