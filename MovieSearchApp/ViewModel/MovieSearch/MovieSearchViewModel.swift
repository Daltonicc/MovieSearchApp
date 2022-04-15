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
        let searchTextFieldBegin: Signal<Void>
        let searchTextFieldEnd: Signal<Void>
        let requestMovieListEvent: Signal<Void>
        let pressFavoriteButtonList: Signal<Void>
    }

    struct Output {
        let searchQuery: Signal<String>
        let showToastAction: Signal<String>
        let indicatorAction: Driver<Bool>
    }

    private let searchQuery = PublishRelay<String>()
    private let showToastAction = PublishRelay<String>()
    private let indicatorAction = BehaviorRelay<Bool>(value: false)

    var disposeBag = DisposeBag()

    func transform(input: Input) -> Output {
        
    }
}

extension MovieSearchViewModel {

}
