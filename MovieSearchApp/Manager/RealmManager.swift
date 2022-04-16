//
//  RealmModel.swift
//  MovieSearchApp
//
//  Created by 박근보 on 2022/04/17.
//

import Foundation
import RealmSwift

enum SortType: String {
    case isFavorite
}

final class RealmManager {
    private init() {
        print(localRealm.configuration.fileURL)
    }

    static let shared = RealmManager()
    
    private let localRealm = try! Realm()

    func saveMovieListData(with list: FavoriteMovieList) {
        try! localRealm.write {
            localRealm.add(list)
        }
    }

    func loadListData() -> Results<FavoriteMovieList> {
        return localRealm.objects(FavoriteMovieList.self)

    }

    func loadListDataBy(sortType: SortType) -> Results<FavoriteMovieList> {
        return localRealm.objects(FavoriteMovieList.self).sorted(byKeyPath: sortType.rawValue, ascending: true)
    }

    func deleteListData(index: Int) {
        let task = localRealm.objects(FavoriteMovieList.self)[index]
        try! localRealm.write {
            localRealm.delete(task)
        }
    }

    func deleteObjectData(object: FavoriteMovieList) {
        try! localRealm.write {
            localRealm.delete(object)
        }
    }

    func updateListData(index: Int, to change: Bool) {
        let task = localRealm.objects(FavoriteMovieList.self)[index]

        try! localRealm.write {
            task.isFavorite = change
        }
    }
}

