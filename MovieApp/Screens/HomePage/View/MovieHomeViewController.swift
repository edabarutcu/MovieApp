//
//  ViewController.swift
//  MovieApp
//
//  Created by Eda Barutçu on 11.11.2023.
//

import UIKit

protocol MovieHomeViewControllerInterface: AnyObject {
    var viewModel: MovieHomeViewModelInterface? {get set}
    
    func setupUI()
    func updateTableView()
    func updateCollectionView()
    func showIndicator()
    func hideIndicator()
    func showAlert(title: String, message: String)
}

class MovieHomeViewController: UIViewController, MovieHomeViewControllerInterface {
    
    var viewModel: MovieHomeViewModelInterface?
    
    private var searchDelay: TimeInterval = 2.0
    private var searchTimer: Timer?
    
    private lazy var movieImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleToFill
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 10
        image.image = UIImage(named: "titleIcon")
        return image
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        searchBar.layer.shadowColor = UIColor.white.cgColor
        return searchBar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        tableView.register(MovieTableCell.self, forCellReuseIdentifier: "MovieTableCell")
        return tableView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 190, height: 190)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor(named: "Background10")
        collectionView.register(MovieCollectionCell.self, forCellWithReuseIdentifier: "MovieCollectionCell")
        return collectionView
    }()
    
    var activityIndicator: UIActivityIndicatorView!
    var isLoadingNextCollectionPage: Bool = false
    var currentCollectionPage = 1
    var isLoadingNextTablePage: Bool = false
    var currentTablePage = 0
    var searchText = "star"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MovieHomeViewModel()
        viewModel?.view = self
        viewModel?.viewDidLoad()
    }
    
    func setupUI() {
        view.backgroundColor = UIColor(named: "Background10")
        UINavigationBar.appearance().tintColor = UIColor.red
        navigationController?.navigationBar.tintColor = UIColor(named: "Gary90")
        
        view.addSubview(movieImage)
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(collectionView)
        
        // Loader Actions
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = UIColor(named: "Gray90") // Set your desired color
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        // Keyboard closes when tap around
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        movieImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.centerX.equalToSuperview()
            make.height.equalTo(70)
            make.width.equalTo(240)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(movieImage.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(42)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(collectionView.snp.top).offset(-32)
        }
        
        collectionView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-2)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(190)
        }
    }
    
    func updateTableView() {
        self.tableView.reloadData()
        isLoadingNextTablePage = false
    }
    
    func updateCollectionView() {
        self.collectionView.reloadData()
        isLoadingNextCollectionPage = false
    }
    
    func showIndicator() {
        self.activityIndicator.startAnimating()
        self.searchBar.resignFirstResponder()
    }
    
    func hideIndicator() {
        self.activityIndicator.stopAnimating()
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func handleTap() {
        view.endEditing(true) // Dismiss the keyboard
    }
}

// MARK: - SearchBar
extension MovieHomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Invalidate previous timer
        searchTimer?.invalidate()
        
        // Schedule a new timer if the search text is not empty
        if !searchText.isEmpty {
            searchTimer = Timer.scheduledTimer(withTimeInterval: searchDelay, repeats: false) { [weak self] timer in
                // Perform your service call after the delay
                self?.handleSearch(with: searchText)
            }
        } else {
            // Handle case where search text is empty (e.g., user tapped "Cancel" button)
            handleSearch(with: "star")
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Handle search button click immediately
        if let searchText = searchBar.text {
            handleSearch(with: searchText)
        }
        searchBar.resignFirstResponder() // Dismiss the keyboard
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchText = "star"
        currentTablePage = 1
        viewModel?.fetchTableMovies(searhcKey: self.searchText, page: 1)
        searchBar.resignFirstResponder() // Dismiss the keyboard
    }
    
    private func handleSearch(with searchText: String) {
        self.searchText = searchText
        currentTablePage = 1
        viewModel?.fetchTableMovies(searhcKey: self.searchText, page: 1)
    }
}


// MARK: - TableView
extension MovieHomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.tableMovieData?.Search?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableCell", for: indexPath) as! MovieTableCell
        
        cell.configure(movieUrl: viewModel?.tableMovieData?.Search?[indexPath.row].Poster ?? "",
                       movieDetailText: "Year : \(viewModel?.tableMovieData?.Search?[indexPath.row].Year ?? "No Data Find")",
                       movieName: viewModel?.tableMovieData?.Search?[indexPath.row].Title ?? "No Data Find")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MovieDetailViewController()
        vc.title = "Movie Detail"
        vc.imdbId = viewModel?.tableMovieData?.Search?[indexPath.row].imdbID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }
}

// MARK: - CollectionView
extension MovieHomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.collectionMovieData?.Search?.count ?? 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionCell", for: indexPath) as! MovieCollectionCell
        cell.configure(movieUrl: viewModel?.collectionMovieData?.Search?[indexPath.row].Poster ?? "",
                       movieDetailText: "Year : \(viewModel?.collectionMovieData?.Search?[indexPath.row].Year ?? "")",
                       movieName: viewModel?.collectionMovieData?.Search?[indexPath.row].Title ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = MovieDetailViewController()
        vc.title = "Movie Detail"
        vc.imdbId = viewModel?.collectionMovieData?.Search?[indexPath.row].imdbID
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Scroll Actions
extension MovieHomeViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView is UICollectionView {
            handleCollectionViewScroll(scrollView)
        } else if scrollView is UITableView {
            handleTableViewScroll(scrollView)
        }
    }
    
    func handleCollectionViewScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let contentWidth = scrollView.contentSize.width
        let screenWidth = scrollView.frame.size.width
        
        if offsetX > contentWidth - screenWidth {
            // User has reached the end of the collection view content
            if !isLoadingNextCollectionPage {
                loadNextCollectionPage()
            }
        }
    }
    
    func handleTableViewScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - screenHeight {
            // User has reached the end of the table view content
            if !isLoadingNextTablePage {
                loadNextTablePage()
            }
        }
    }
    
    func loadNextCollectionPage() {
        isLoadingNextCollectionPage = true
        currentCollectionPage += 1
        
        viewModel?.fetchCollectionMovies(searhcKey: "comedy", page: currentCollectionPage)
    }
    
    func loadNextTablePage() {
        isLoadingNextTablePage = true
        currentTablePage += 1
        
        viewModel?.fetchTableMovies(searhcKey: searchText, page: currentTablePage)
    }
}

