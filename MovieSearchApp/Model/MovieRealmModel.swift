//
//  MovieRealmModel.swift
//  MovieSearchApp
//
//  Created by 박근보 on 2022/04/17.
//

import Foundation
import RealmSwift

final class FavoriteMovieList: Object {

    @Persisted var title: String
    @Persisted var link: String
    @Persisted var image: String
    @Persisted var director: String
    @Persisted var actor: String
    @Persisted var userRating: String
    @Persisted var isFavorite: Bool

    @Persisted(primaryKey: true) var _id: ObjectId

    convenience init(title: String, link: String, image: String, director: String, actor: String, userRating: String, isFavorite: Bool) {
        self.init()

        self.title = title
        self.link = link
        self.image = image
        self.director = director
        self.actor = actor
        self.userRating = userRating
        self.isFavorite = isFavorite
    }
}
