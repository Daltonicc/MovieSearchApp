//
//  FavoriteViewModel.swift
//  MovieSearchApp
//
//  Created by 박근보 on 2022/04/17.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

final class FavoriteViewModel: ViewModelType {

    struct Input {
        let requestFavoriteMovieListEvent: Signal<Void>
        let requestRemoveFavoriteEvent: Signal<Int>
        let pressFavoriteButton: Signal<Int>
        let pressMovieItem: Signal<Int>
    }

    struct Output {
        let didLoadFavoriteMovieList: Driver<[MovieItem]>
        let noResultAction: Driver<Bool>
        let didPressFavoriteButton: Signal<Int>
        let didPressMovieItem: Signal<MovieItem>
    }

    private let didLoadFavoriteMovieList = BehaviorRelay<[MovieItem]>(value: [])
    private let noResultAction = BehaviorRelay<Bool>(value: true)
    private let didPressFavoriteButton = PublishRelay<Int>()
    private let didPressMovieItem = PublishRelay<MovieItem>()

    var disposeBag = DisposeBag()

    var favoriteMovieData: [MovieItem] = []

    // Database
    private var favoriteMovieList: Results<FavoriteMovieList>! {
        return RealmManager.shared.loadListData()
    }

    func transform(input: Input) -> Output {

        // 즐겨찾기 목록 요청 받았을 때
        input.requestFavoriteMovieListEvent
            .emit { [weak self] _ in
                guard let self = self else { return }
                self.getFavoriteMovieData()
                self.noResultAction.accept(self.checkEmptyList())
                self.didLoadFavoriteMovieList.accept(self.favoriteMovieData)
            }
            .disposed(by: disposeBag)

        // 즐겨찾기 목록에서 제거 요청 받았을 때
        input.requestRemoveFavoriteEvent
            .emit { [weak self] row in
                guard let self = self else { return }
                self.removeFavoriteData(row: row)
                self.getFavoriteMovieData()
                self.noResultAction.accept(self.checkEmptyList())
                self.didLoadFavoriteMovieList.accept(self.favoriteMovieData)
            }
            .disposed(by: disposeBag)

        // 즐겨찾기 버튼 눌렀을 때
        input.pressFavoriteButton
            .emit { [weak self] row in
                guard let self = self else { return }
                self.didPressFavoriteButton.accept(row)
            }
            .disposed(by: disposeBag)

        // 셀 클릭했을 때
        input.pressMovieItem
            .emit { [weak self] row in
                guard let self = self else { return }
                self.didPressMovieItem.accept(self.favoriteMovieData[row])
            }
            .disposed(by: disposeBag)

        return Output(
            didLoadFavoriteMovieList: didLoadFavoriteMovieList.asDriver(),
            noResultAction: noResultAction.asDriver(),
            didPressFavoriteButton: didPressFavoriteButton.asSignal(),
            didPressMovieItem: didPressMovieItem.asSignal()
        )
    }
}

extension FavoriteViewModel {

    private func getFavoriteMovieData() {
        favoriteMovieData.removeAll()
        for i in 0..<favoriteMovieList.count {
            let data = MovieItem(title: favoriteMovieList[i].title,
                                 link: favoriteMovieList[i].link,
                                 image: favoriteMovieList[i].image,
                                 director: favoriteMovieList[i].director,
                                 actor: favoriteMovieList[i].actor,
                                 userRating: favoriteMovieList[i].userRating,
                                 isFavorite: favoriteMovieList[i].isFavorite)
            favoriteMovieData.append(data)
        }
    }

    private func checkEmptyList() -> Bool {
        favoriteMovieData.count == 0 ? false : true
    }

    private func removeFavoriteData(row: Int) {
        RealmManager.shared.deleteListData(index: row)
    }
}
