//
//  MovieDataDTO.swift
//  MovieSearchApp
//
//  Created by 박근보 on 2022/04/15.
//

import Foundation

struct ResponseMovieDataDTO: Codable {
    let lastBuildDate: String
    let total, start, display: Int
    let items: [Item]
}

struct Item: Codable {
    let title: String
    let link: String
    let image: String
    let director: String
    let actor: String
    let userRating: String
}

extension ResponseMovieDataDTO {
    func toEntity() -> MovieData {
        return .init(total: total,
                     start: start,
                     display: display,
                     items: items.map { $0.toEntity() })
    }
}

extension Item {
    func toEntity() -> MovieItem {

        let title = title
            .replacingOccurrences(of: "<b>", with: "")
            .replacingOccurrences(of: "</b>", with: "")
        var director = director
            .replacingOccurrences(of: "|", with: ", ")
            .replacingOccurrences(of: "<b>", with: "")
            .replacingOccurrences(of: "</b>", with: "")
        var actor = actor
            .replacingOccurrences(of: "|", with: ", ")
            .replacingOccurrences(of: "<b>", with: "")
            .replacingOccurrences(of: "</b>", with: "")
        if director.count >= 1 {
            director.removeLast()
            director.removeLast()
        }
        if actor.count >= 1 {
            actor.removeLast()
            actor.removeLast()
        }

        return .init(title: title,
                     link: link,
                     image: image,
                     director: director,
                     actor: actor,
                     userRating: userRating,
                     isFavorite: false)
    }
}
