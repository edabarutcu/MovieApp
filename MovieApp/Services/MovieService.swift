//
//  MovieService.swift
//  MovieApp
//
//  Created by Eda Barutçu on 11.11.2023.
//

import Foundation

struct MovieService {
    
    static let apiKey = "d955c43d"
    static let baseURL = "https://www.omdbapi.com/"
    
    static func searchMovies(searchTerm: String, page: Int) async throws -> MovieResponseModel {
        // Encode the search term to make it URL-safe
        guard let encodedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            // Handle encoding error
            throw MovieServiceError.encodingError
        }
        
        // Build the URL with the dynamic parameters
        let urlString = "\(baseURL)?s=\(encodedSearchTerm)&page=\(page)&apikey=\(apiKey)"
        guard let url = URL(string: urlString) else {
            // Handle URL creation error
            throw MovieServiceError.urlCreationError
        }
        
        // Perform the URL request asynchronously using Task
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // Decode the JSON data into MovieResponseModel
        let decoder = JSONDecoder()
        return try decoder.decode(MovieResponseModel.self, from: data)
    }
    
    static func movieDetail(imdbId: String) async throws -> MovieDetailResponseModel {
        
        let urlString = "\(baseURL)?i=\(imdbId)&apikey=\(apiKey)"
        guard let url = URL(string: urlString) else {
            throw MovieServiceError.urlCreationError
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
        return try decoder.decode(MovieDetailResponseModel.self, from: data)
    }
}

enum MovieServiceError: Error {
    case encodingError
    case urlCreationError
}
