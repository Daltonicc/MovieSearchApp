//
//  DetailViewModel.swift
//  MovieSearchApp
//
//  Created by 박근보 on 2022/04/17.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

final class DetailViewModel: ViewModelType {

    struct Input {
        let pressFavoriteButton: Signal<MovieItem>
    }

    struct Output {
        let didPressFavoriteButton: Signal<Void>
    }

    private let didPressFavoriteButton = PublishRelay<Void>()

    var disposeBag = DisposeBag()

    private var favoriteMovieList: Results<FavoriteMovieList>! {
        return RealmManager.shared.loadListData()
    }

    func transform(input: Input) -> Output {

        // 즐겨찾기 버튼 눌렀을 때
        input.pressFavoriteButton
            .emit { [weak self] item in
                guard let self = self else { return }
                self.checkFavoriteList(item: item)
                self.didPressFavoriteButton.accept(())
            }
            .disposed(by: disposeBag)

        return Output(
            didPressFavoriteButton: didPressFavoriteButton.asSignal()
        )
    }
}

extension DetailViewModel {
    private func checkFavoriteList(item: MovieItem) {
        let filterValue = favoriteMovieList.filter ("title = '\(item.title)'")
        if filterValue.count == 0 {
            addToDataBase(movieItem: item)
        } else {
            for i in 0..<favoriteMovieList.count {
                if favoriteMovieList[i].title == item.title {
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
    
}
