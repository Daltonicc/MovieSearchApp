//
//  MovieSearchViewModel.swift
//  MovieSearchApp
//
//  Created by 박근보 on 2022/04/15.
//

import Foundation
import RxSwift
import RxCocoa

final class MovieSearchViewModel: ViewModelType {

    struct Input {
        let requestMovieListEvent: Signal<String>
        let requestNextPageMovieListEvent: Signal<String>
        let pressFavoriteButtonList: Signal<Void>
    }

    struct Output {
        let failToastAction: Signal<String>
        let indicatorAction: Driver<Bool>
        let didLoadMovieData: Driver<[MovieItem]>
        let didLoadFavoirteView: Signal<Void>
        let noResultAction: Driver<Bool>
    }

    private let failToastAction = PublishRelay<String>()
    private let indicatorAction = BehaviorRelay<Bool>(value: false)
    private let didLoadMovieData = BehaviorRelay<[MovieItem]>(value: [])
    private let didLoadFavoriteView = PublishRelay<Void>()
    private let noResultAction = BehaviorRelay<Bool>(value: false)

    var disposeBag = DisposeBag()

    var start = 1
    var display = 20
    var total = 0

    var totalMovieData: [MovieItem] = []

    func transform(input: Input) -> Output {

        input.requestMovieListEvent
            .emit { [weak self] query in
                guard let self = self else { return }
                self.totalMovieData.removeAll()
                self.getMovieData(query: query) { response in
                    switch response {
                    case .success(let data):
                        self.total = data.total
                        self.appendData(movieItem: data.items)
                        self.didLoadMovieData.accept(self.totalMovieData)
                    case .failure(let error):
                        self.failToastAction.accept(error.errorDescription!)
                    }
                }
            }
            .disposed(by: disposeBag)

        input.requestNextPageMovieListEvent
            .emit { [weak self] query in
                guard let self = self else { return }
                print("input")
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

        return Output(
            failToastAction: failToastAction.asSignal(),
            indicatorAction: indicatorAction.asDriver(),
            didLoadMovieData: didLoadMovieData.asDriver(),
            didLoadFavoirteView: didLoadFavoriteView.asSignal(),
            noResultAction: noResultAction.asDriver()
        )
    }
}

extension MovieSearchViewModel {

    func getMovieData(query: String, completion: @escaping (Result<(MovieData), MovieError>) -> Void) {
        total = 0
        start = 1
        display = 20
        APIManager.shared.getMovieData(query: query, start: start, display: display, completion: completion)
    }

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

    func appendData(movieItem: [MovieItem]) {
        for i in movieItem {
            totalMovieData.append(i)
        }
    }
}
