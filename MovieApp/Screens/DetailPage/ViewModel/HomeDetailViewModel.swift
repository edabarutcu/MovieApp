//
//  HomeDetailViewModel.swift
//  MovieApp
//
//  Created by Eda Barutçu on 12.11.2023.
//

import Foundation

protocol MovieDetailViewModelInterface {
    var view: MovieDetailViewControllerInterface? {get set}
    
    var detailData: MovieDetailResponseModel? { get set }
    
    func viewDidLoad()
    func fetchMovieDetail(imdbID: String)
}

final class MovieDetailViewModel: MovieDetailViewModelInterface {
    weak var view: MovieDetailViewControllerInterface?
    
    var detailData: MovieDetailResponseModel?
    
    func viewDidLoad() {
        view?.setupUI()
        fetchMovieDetail(imdbID: view?.imdbId ?? "")
    }
    
    func fetchMovieDetail(imdbID: String) {
        view?.showIndicator()
        Task {
            do {
                let response = try await MovieService.movieDetail(imdbId: imdbID)
                self.detailData = response
                DispatchQueue.main.async {
                    self.view?.updateUI()
                    self.view?.hideIndicator()
                }
            } catch {
                view?.hideIndicator()
            }
        }
    }
}

