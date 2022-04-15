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
        let pressFavoriteButtonList: Signal<Void>
    }

    struct Output {
        let failToastAction: Signal<String>
        let indicatorAction: Driver<Bool>
        let didLoadMovieData: Driver<[MovieItem]>
        let noResultAction: Driver<Bool>
    }

    private let failToastAction = PublishRelay<String>()
    private let indicatorAction = BehaviorRelay<Bool>(value: false)
    private let didLoadMovieData = BehaviorRelay<[MovieItem]>(value: [])
    private let noResultAction = BehaviorRelay<Bool>(value: false)

    var disposeBag = DisposeBag()

    func transform(input: Input) -> Output {

        input.requestMovieListEvent
            .emit { [weak self] query in
                guard let self = self else { return }
                self.getMovieData(query: query) { response in
                    switch response {
                    case .success(let data):
                        self.didLoadMovieData.accept(data.items)
                    case .failure(let error):
                        self.failToastAction.accept(error.errorDescription!)
                    }
                }
            }
            .disposed(by: disposeBag)

        return Output(
            failToastAction: failToastAction.asSignal(),
            indicatorAction: indicatorAction.asDriver(),
            didLoadMovieData: didLoadMovieData.asDriver(),
            noResultAction: noResultAction.asDriver()
        )
    }
}

extension MovieSearchViewModel {

    func getMovieData(query: String, completion: @escaping (Result<(MovieData), MovieError>) -> Void) {
        let start = 1
        let display = 20
        APIManager.shared.getMovieData(query: query, start: start, display: display, completion: completion)
    }
}
