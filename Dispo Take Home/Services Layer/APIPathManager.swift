//
//  APIManager.swift
//  Dispo Take Home
//
//  Created by Julian Builes on 1/20/22.
//

import Foundation

/**
        Responsible for all API path-related logic.
    
    - Author: Julian Builes
*/
struct APIPathManager {

    private static let GiphyAPIKeyValue = "dEKpEzNW4mNvFTfAb7d5bfalNzR5V6LA"
    
    enum Constants {
        static let GiphyAPIKey = URLQueryItem(name: "api_key", value: GiphyAPIKeyValue)
        static let PGRatingQueryParam = URLQueryItem(name: "rating", value: MPAARating.pg.rawValue)
        static let SearchURLKeyParam = "q"
        static let GiphyBaseURL = "https://api.giphy.com/v1/gifs"
    }
    
    enum Path {
        
        case trending
        case byID(String)
        case search(String)
        
        private func urlPath() -> String {
            switch self {
                case .trending: return "/trending"
                case .byID(let id): return "/\(id)"
                case .search: return "/search"
            }
        }
        
        private func params() -> [URLQueryItem] {
            switch self {
            case .trending: return [ Constants.GiphyAPIKey, APIPathManager.Constants.PGRatingQueryParam ]
            case .search(let searchTerm): return [ Constants.GiphyAPIKey, URLQueryItem(name: Constants.SearchURLKeyParam, value: searchTerm) ]
            case .byID: return [ Constants.GiphyAPIKey ]
            }
        }
        
        func url() -> URL? {
            var url = URLComponents(string: Constants.GiphyBaseURL + urlPath())
            url?.queryItems = params()
            return url?.url
        }
    }
}
