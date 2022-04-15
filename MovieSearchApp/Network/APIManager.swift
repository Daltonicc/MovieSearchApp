//
//  APIManager.swift
//  MovieSearchApp
//
//  Created by 박근보 on 2022/04/15.
//

import Foundation
import Alamofire

enum MovieAPI {
    case getMovieData(query: String, start: String, display: String)
}

extension MovieAPI {

    var url: URL {
        return URL(string: "https://openapi.naver.com/v1/search/movie.json")!
    }

    var parameters: [String: String] {
        switch self {
        case .getMovieData(let query, let start, let display):
            return [
                "query": query,
                "display": display,
                "start": start
            ]
        }
    }

    var headers: HTTPHeaders {
        switch self {
        default:
            return [
                "X-Naver-Client-Id": APIKey.clientID,
                "X-Naver-Client-Secret": APIKey.clientSecret
            ]
        }
    }
}

final class APIManager {

    static let shared = APIManager()

    func getMovieData(query: String, start: String, display: String, completion: @escaping (Result<(MovieData), MovieError>) -> Void) {

        let movieAPI: MovieAPI = .getMovieData(query: query, start: start, display: display)

        AF.request(movieAPI.url, method: .get, parameters: movieAPI.parameters, headers: movieAPI.headers)
            .validate()
            .responseDecodable(of: MovieData.self) { [weak self] response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(_):
                    guard let statusCode = response.response?.statusCode else { return }
                    guard let error = self?.statusCodeCheck(statusCode: statusCode) else { return }
                    completion(.failure(error))
                }
            }
    }

    private func statusCodeCheck(statusCode: Int) -> MovieError {
        switch statusCode {
        case 400: return .incorrectQuery
        case 401: return .failAuthorization
        case 403: return .serverError
        case 404: return .invalidAPI
        case 429: return .tooMuchRequest
        case 500: return .systemError
        default: return .systemError
        }
    }
}
