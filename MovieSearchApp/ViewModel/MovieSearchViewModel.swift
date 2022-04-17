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
        let pressFavoriteButtonList: Signal<Void>
        let pressFavoriteButton: Signal<Int>
        let pressMovieItem: Signal<Int>
    }

    struct Output {
        let failToastAction: Signal<String>
        let didLoadMovieData: Driver<[MovieItem]>
        let didLoadFavoriteView: Signal<Void>
        let noResultAction: Driver<Bool>
        let didPressMovieItem: Signal<MovieItem>
    }

    private let failToastAction = PublishRelay<String>()
    private let didLoadMovieData = BehaviorRelay<[MovieItem]>(value: [])
    private let didLoadFavoriteView = PublishRelay<Void>()
    private let noResultAction = BehaviorRelay<Bool>(value: true)
    private let didPressMovieItem = PublishRelay<MovieItem>()

    var disposeBag = DisposeBag()

    private var start = 1
    private var display = 20
    private var total = 0

    var totalMovieData: [MovieItem] = []

    // Database
    private let localRealm = try! Realm()
    private var favoriteMovieList: Results<FavoriteMovieList>! {
        return RealmManager.shared.loadListData()
    }

    func transform(input: Input) -> Output {

        // 영화 리스트 요청 받았을 때
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
                        self.checkMovieList()
                        self.didLoadMovieData.accept(self.totalMovieData)
                        self.noResultAction.accept(noResultCheck)
                    case .failure(let error):
                        self.failToastAction.accept(error.errorDescription!)
                    }
                }
            }
            .disposed(by: disposeBag)

        // 다음 페이지 리스트 요청 받았을 때 - 페이지네이션
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

        // 즐겨찾기 목록 이동 버튼 눌렀을 때
        input.pressFavoriteButtonList
            .emit { [weak self] _ in
                guard let self = self else { return }
                self.didLoadFavoriteView.accept(())
            }
            .disposed(by: disposeBag)

        // 즐겨찾기 버튼 눌렀을 때
        input.pressFavoriteButton
            .emit { [weak self] row in
                guard let self = self else { return }
                self.totalMovieData[row].isFavorite.toggle()
                self.checkFavoriteList(row: row)
                self.didLoadMovieData.accept(self.totalMovieData)
            }
            .disposed(by: disposeBag)

        // 셀 클릭했을 때
        input.pressMovieItem
            .emit { [weak self] row in
                guard let self = self else { return }
                self.didPressMovieItem.accept(self.totalMovieData[row])
            }
            .disposed(by: disposeBag)

        return Output(
            failToastAction: failToastAction.asSignal(),
            didLoadMovieData: didLoadMovieData.asDriver(),
            didLoadFavoriteView: didLoadFavoriteView.asSignal(),
            noResultAction: noResultAction.asDriver(),
            didPressMovieItem: didPressMovieItem.asSignal()
        )
    }
}

extension MovieSearchViewModel {

    private func getMovieData(query: String, completion: @escaping (Result<MovieData, MovieError>) -> Void) {
        total = 0
        start = 1
        APIManager.shared.getMovieData(query: query, start: start, display: display, completion: completion)
    }

    // 마지막 페이지 확인하고 데이터 Fetch 해주는 Logic
    private func getNextPageMovieData(query: String, completion: @escaping (Result<MovieData, MovieError>) -> Void) {
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
    private func checkNoResult(movieItem: [MovieItem]) -> Bool {
        if movieItem.count == 0 {
            return false
        } else {
            return true
        }
    }

    // 검색한 영화리스트에서 즐겨찾기 목록에 있는지 확인해주고 있다면 isFavorite을 True로 바꿔주는 메서드
    private func checkMovieList() {
        for i in 0..<totalMovieData.count {
            let filterValue = favoriteMovieList.filter ("title = '\(self.totalMovieData[i].title)'")
            if filterValue.count == 1 {
                totalMovieData[i].isFavorite = true
            }
        }
    }

    // 즐겨찾기 DB 목록에 있는지 확인하고 있으면 삭제, 없으면 등록하는 Logic
    private func checkFavoriteList(row: Int) {
        let filterValue = favoriteMovieList.filter ("title = '\(self.totalMovieData[row].title)'")
        if filterValue.count == 0 {
            addToDataBase(movieItem: totalMovieData[row])
        } else {
            for i in 0..<favoriteMovieList.count {
                if favoriteMovieList[i].title == totalMovieData[row].title {
                    removeFromDataBase(movieItem: favoriteMovieList[i])
                    return
                }
            }
        }
    }

    private func addToDataBase(movieItem: MovieItem) {
        let task = FavoriteMovieList(title: movieItem.title,
                                     link: movieItem.link,
                                     image: movieItem.image,
                                     director: movieItem.director,
                                     actor: movieItem.actor,
                                     userRating: movieItem.userRating,
                                     isFavorite: true)
        RealmManager.shared.saveMovieListData(with: task)
    }

    private func removeFromDataBase(movieItem: FavoriteMovieList) {
        RealmManager.shared.deleteObjectData(object: movieItem)
    }

    private func appendData(movieItem: [MovieItem]) {
        for i in movieItem {
            totalMovieData.append(i)
        }
    }
}
