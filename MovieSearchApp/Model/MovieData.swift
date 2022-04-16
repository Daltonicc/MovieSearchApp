//
//  MovieData.swift
//  MovieSearchApp
//
//  Created by 박근보 on 2022/04/17.
//

import Foundation

struct MovieData {
    let total, start, display: Int
    let items: [MovieItem]
}


struct MovieItem {
    let title: String
    let link: String
    let image: String
    let director: String
    let actor: String
    let userRating: String
    let isFavorite: Bool
}
