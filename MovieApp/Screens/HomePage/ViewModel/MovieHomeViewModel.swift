//
//  MovieHomeViewModel.swift
//  MovieApp
//
//  Created by Eda Barutçu on 10.11.2023.
//

import Foundation

protocol MovieHomeViewModelInterface {
    var view: MovieHomeViewControllerInterface? {get set}
    
    var tableMovieData: MovieResponseModel? { get set }
    var collectionMovieData: MovieResponseModel? { get set }
    
    func viewDidLoad()
    func fetchTableMovies(searhcKey: String, page: Int)
    func fetchCollectionMovies(searhcKey: String, page: Int)
    
}

final class MovieHomeViewModel: MovieHomeViewModelInterface {
    
    weak var view: MovieHomeViewControllerInterface?
    
    var tableMovieData: MovieResponseModel?
    var collectionMovieData: MovieResponseModel?
    
    private var isFetchingCollectionData = false
    private var isFetchingTableData = false
    var searchText = "Star"
    
    @MainActor
    func viewDidLoad() {
        view?.setupUI()
        fetchTableMovies(searhcKey: searchText, page: 1)
        fetchCollectionMovies(searhcKey: "Comedy", page: 1)
    }
    
    @MainActor
    func fetchTableMovies(searhcKey: String, page: Int) {
        if searchText != searhcKey {
            tableMovieData = nil
        }
        searchText = searhcKey
        
        guard !isFetchingTableData else {
            return
        }
        
        isFetchingTableData = true
        
        view?.showIndicator()
        
        Task {
            do {
                let movieResponse = try await MovieService.searchMovies(searchTerm: searhcKey, page: page)
                if movieResponse.Search == nil {
                    view?.showAlert(title: "Searching Alert", message: "Search is not successful.\nPlease enter at least 3 characters \nand provide a meaningful \nEnglish search term.")
                    view?.hideIndicator()
                } else {
                    if var currentMovies = tableMovieData?.Search {
                        currentMovies.append(contentsOf: movieResponse.Search ?? [])
                        tableMovieData?.Search = currentMovies
                    } else {
                        tableMovieData = movieResponse
                    }
                    DispatchQueue.main.async {
                        self.view?.updateTableView()
                        self.view?.hideIndicator()
                    }
                    
                    isFetchingTableData = false
                }
                
            } catch {
                view?.hideIndicator()
            }
            
            isFetchingTableData = false
        }
    }
    
    @MainActor
    func fetchCollectionMovies(searhcKey: String, page: Int) {
        
        guard !isFetchingCollectionData else {
            return
        }
        
        isFetchingCollectionData = true
        
        view?.showIndicator()
        
        Task {
            do {
                let movieResponse = try await MovieService.searchMovies(searchTerm: searhcKey, page: page)
                
                // Assuming you have a property to store the loaded movies
                if var currentMovies = collectionMovieData?.Search {
                    currentMovies.append(contentsOf: movieResponse.Search ?? [])
                    collectionMovieData?.Search = currentMovies
                } else {
                    collectionMovieData = movieResponse
                }
                DispatchQueue.main.async {
                    self.view?.updateCollectionView()
                    self.view?.hideIndicator()
                }
                
                isFetchingCollectionData = false
            } catch {
                view?.hideIndicator()
            }
            
            isFetchingCollectionData = false
        }
    }    
}
