//
//  NetworkError.swift
//  MovieSearchApp
//
//  Created by 박근보 on 2022/04/15.
//

import Foundation

enum MovieError: Int, Error {
    case incorrectQuery = 400
    case failAuthorization = 401
    case serverError = 403
    case invalidAPI = 404
    case tooMuchRequest = 429
    case systemError = 500
}

extension MovieError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .incorrectQuery: return "검색어를 다시 확인해주세요"
        case .failAuthorization: return "사용자 인증에 실패했습니다"
        case .serverError: return "서버 에러입니다"
        case .invalidAPI: return "존재하지 않는 검색 API입니다"
        case .tooMuchRequest: return "허용량을 초과했습니다"
        case .systemError: return "시스템 에러입니다"
        }
    }
}
