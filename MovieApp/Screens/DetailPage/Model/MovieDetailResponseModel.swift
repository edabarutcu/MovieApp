//
//  MovieDetailResponseModel.swift
//  MovieApp
//
//  Created by Eda Barutçu on 12.11.2023.
//

import Foundation

struct MovieDetailResponseModel: Codable {
    let Title, Year, Released: String?
    let Runtime, Genre, Director, Writer: String?
    let Actors, Plot: String?
    let Awards, Poster: String?
    let imdbRating: String?
}
