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
        let requestWebView: Signal<MovieItem>
    }

    struct Output {
        let didPressFavoriteButton: Signal<Void>
        let didLoadWebView: Signal<URLRequest>
        let indicatorAction: Driver<Bool>
    }

    private let didPressFavoriteButton = PublishRelay<Void>()
    private let didLoadWebView = PublishRelay<URLRequest>()
    private let indicatorAction = BehaviorRelay<Bool>(value: false)

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

        input.requestWebView
            .emit { [weak self] item in
                guard let self = self else { return }
                guard let item = self.webViewConfig(movieItem: item) else { return }
                self.indicatorAction.accept(true)
                DispatchQueue.main.async {
                    self.didLoadWebView.accept(item)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.indicatorAction.accept(false)
                    }
                }
            }
            .disposed(by: disposeBag)

        return Output(
            didPressFavoriteButton: didPressFavoriteButton.asSignal(),
            didLoadWebView: didLoadWebView.asSignal(),
            indicatorAction: indicatorAction.asDriver()
        )
    }
}

extension DetailViewModel {
    
    private func checkFavoriteList(item: MovieItem) {
        let filterValue = favoriteMovieList.filter ("title = '\(item.title)' AND director = '\(item.director)'")
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

    private func webViewConfig(movieItem: MovieItem) -> URLRequest? {
        guard let url = URL(string: movieItem.link) else { return nil }
        return URLRequest(url: url)
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
