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
        let pressFavoriteButton: Signal<Int>
        let pressMovieItem: Signal<Int>
    }

    struct Output {
        let didLoadFavoriteMovieList: Driver<[MovieItem]>
        let indicatorAction: Driver<Bool>
        let noResultAction: Driver<Bool>
        let didPressFavoriteButton: Signal<Void>
        let didPressMovieItem: Signal<MovieItem>
    }

    private let didLoadFavoriteMovieList = BehaviorRelay<[MovieItem]>(value: [])
    private let indicatorAction = BehaviorRelay<Bool>(value: false)
    private let noResultAction = BehaviorRelay<Bool>(value: true)
    private let didPressFavoriteButton = PublishRelay<Void>()
    private let didPressMovieItem = PublishRelay<MovieItem>()

    var disposeBag = DisposeBag()

    private var favoriteMovieData: [MovieItem] = []

    // Database
    private let localRealm = try! Realm()
    private var favoriteMovieList: Results<FavoriteMovieList>! {
        return RealmManager.shared.loadListData()
    }

    func transform(input: Input) -> Output {

        input.requestFavoriteMovieListEvent
            .emit { [weak self] _ in
                guard let self = self else { return }
                self.getFavoriteMovieData()
                self.didLoadFavoriteMovieList.accept(self.favoriteMovieData)
            }
            .disposed(by: disposeBag)

        return Output(
            didLoadFavoriteMovieList: didLoadFavoriteMovieList.asDriver(),
            indicatorAction: indicatorAction.asDriver(),
            noResultAction: noResultAction.asDriver(),
            didPressFavoriteButton: didPressFavoriteButton.asSignal(),
            didPressMovieItem: didPressMovieItem.asSignal()
        )
    }
}

extension FavoriteViewModel {

    func getFavoriteMovieData() {
        for i in 0..<favoriteMovieList.count {
            let data = MovieItem(title: favoriteMovieList[i].title,
                                 link: favoriteMovieList[i].link,
                                 image: favoriteMovieList[i].image,
                                 director: favoriteMovieList[i].director,
                                 actor: favoriteMovieList[i].actor,
                                 userRating: favoriteMovieList[i].userRating)
            favoriteMovieData.append(data)
        }
    }
}
