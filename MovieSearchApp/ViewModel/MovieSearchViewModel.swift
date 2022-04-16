//
//  MovieSearchViewModel.swift
//  MovieSearchApp
//
//  Created by 박근보 on 2022/04/15.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

final class MovieSearchViewModel: ViewModelType {

    struct Input {
        let requestMovieListEvent: Signal<String>
        let requestNextPageMovieListEvent: Signal<String>
        let requestFavoriteMovieListEvent: Signal<Void>
        let pressFavoriteButtonList: Signal<Void>
        let pressFavoriteButton: Signal<Int>
        let pressMovieItem: Signal<Int>
    }

    struct Output {
        let failToastAction: Signal<String>
        let indicatorAction: Driver<Bool>
        let didLoadMovieData: Driver<[MovieItem]>
        let didLoadFavoriteView: Signal<Void>
        let noResultAction: Driver<Bool>
        let didPressFavoriteButton: Signal<Void>
        let didPressMovieItem: Signal<MovieItem>
    }

    private let failToastAction = PublishRelay<String>()
    private let indicatorAction = BehaviorRelay<Bool>(value: false)
    private let didLoadMovieData = BehaviorRelay<[MovieItem]>(value: [])
    private let didLoadFavoriteView = PublishRelay<Void>()
    private let noResultAction = BehaviorRelay<Bool>(value: true)
    private let didPressFavoriteButton = PublishRelay<Void>()
    private let didPressMovieItem = PublishRelay<MovieItem>()

    var disposeBag = DisposeBag()

    private var start = 1
    private var display = 20
    private var total = 0

    // Database
    private let localRealm = try! Realm()
    private var favoriteMovieList: Results<FavoriteMovieList>! {
        return RealmManager.shared.loadListData()
    }

    var totalMovieData: [MovieItem] = []
    var favoriteMovieData: [MovieItem] = []

    func transform(input: Input) -> Output {

        input.requestMovieListEvent
            .emit { [weak self] query in
                guard let self = self else { return }
                self.totalMovieData.removeAll()
                self.getMovieData(query: query) { response in
                    switch response {
                    case .success(let data):
                        let noResultCheck = self.checkNoResult(movieItem: data.items)
                        self.total = data.total
                        self.appendData(movieItem: data.items)
                        self.didLoadMovieData.accept(self.totalMovieData)
                        self.noResultAction.accept(noResultCheck)
                    case .failure(let error):
                        self.failToastAction.accept(error.errorDescription!)
                    }
                }
            }
            .disposed(by: disposeBag)

        input.requestNextPageMovieListEvent
            .emit { [weak self] query in
                guard let self = self else { return }
                self.getNextPageMovieData(query: query) { response in
                    switch response {
                    case .success(let data):
                        self.appendData(movieItem: data.items)
                        self.didLoadMovieData.accept(self.totalMovieData)
                    case .failure(let error):
                        self.failToastAction.accept(error.errorDescription!)
                    }
                }
            }
            .disposed(by: disposeBag)

        input.pressFavoriteButtonList
            .emit { [weak self] _ in
                guard let self = self else { return }
                self.didLoadFavoriteView.accept(())
            }
            .disposed(by: disposeBag)

        input.pressFavoriteButton
            .emit { [weak self] row in
                guard let self = self else { return }
                self.checkFavoriteList(row: row)
                self.didPressFavoriteButton.accept(())
            }
            .disposed(by: disposeBag)

        input.pressMovieItem
            .emit { [weak self] row in
                guard let self = self else { return }
                self.didPressMovieItem.accept(self.totalMovieData[row])
            }
            .disposed(by: disposeBag)

        return Output(
            failToastAction: failToastAction.asSignal(),
            indicatorAction: indicatorAction.asDriver(),
            didLoadMovieData: didLoadMovieData.asDriver(),
            didLoadFavoriteView: didLoadFavoriteView.asSignal(),
            noResultAction: noResultAction.asDriver(),
            didPressFavoriteButton: didPressFavoriteButton.asSignal(),
            didPressMovieItem: didPressMovieItem.asSignal()
        )
    }
}

extension MovieSearchViewModel {

    func getMovieData(query: String, completion: @escaping (Result<(MovieData), MovieError>) -> Void) {
        total = 0
        start = 1
        APIManager.shared.getMovieData(query: query, start: start, display: display, completion: completion)
    }

    // 마지막 페이지 확인하고 데이터 Fetch 해주는 Logic
    func getNextPageMovieData(query: String, completion: @escaping (Result<(MovieData), MovieError>) -> Void) {
        start += 20
        if start + display < total {
            APIManager.shared.getMovieData(query: query, start: start, display: display, completion: completion)
        } else if start + display >= total && start < total {
            APIManager.shared.getMovieData(query: query, start: start, display: total - start, completion: completion)
        } else {
            return
        }
    }

    // 결과값 있는지, 없는지 확인하는 Logic
    func checkNoResult(movieItem: [MovieItem]) -> Bool {
        if movieItem.count == 0 {
            return false
        } else {
            return true
        }
    }

    func checkFavoriteList(row: Int) {

        let filterValue = favoriteMovieList.filter { $0.title == self.totalMovieData[row].title }
        if filterValue.count == 0 {
            addToDataBase(movieItem: totalMovieData[row])
        } else {
            for i in 0..<favoriteMovieList.count {
                if favoriteMovieList[i].title == totalMovieData[row].title {
                    removeFromDataBase(movieItem: favoriteMovieList[i])
                }
            }
        }
    }

    func addToDataBase(movieItem: MovieItem) {
        let task = FavoriteMovieList(title: movieItem.title,
                                     link: movieItem.link,
                                     image: movieItem.image,
                                     director: movieItem.director,
                                     actor: movieItem.actor,
                                     userRating: movieItem.userRating,
                                     isFavorite: true)
        RealmManager.shared.saveMovieListData(with: task)
    }

    func removeFromDataBase(movieItem: FavoriteMovieList) {
        RealmManager.shared.deleteObjectData(object: movieItem)
    }

    func appendData(movieItem: [MovieItem]) {
        for i in movieItem {
            totalMovieData.append(i)
        }
    }
}
