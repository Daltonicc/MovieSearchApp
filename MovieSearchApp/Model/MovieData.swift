//
//  MovieData.swift
//  MovieSearchApp
//
//  Created by 박근보 on 2022/04/15.
//

import Foundation

struct MovieData: Codable {
    let lastBuildDate: String
    let total, start, display: Int
    let items: [MovieItem]
}

struct MovieItem: Codable {
    let title: String
    let link: String
    let image: String
    let subtitle, pubDate, director, actor: String 
    let userRating: String
}
