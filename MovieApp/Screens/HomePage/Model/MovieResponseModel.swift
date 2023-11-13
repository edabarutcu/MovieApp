//
//  MovieResponseModel.swift
//  MovieApp
//
//  Created by Eda Barutçu on 11.11.2023.
//

import Foundation

struct MovieResponseModel: Decodable {
    var Search: [Search]?
    let totalResults, Response: String?
}

struct Search: Decodable {
    let Title, Year, imdbID: String?
    let Poster: String?
}

