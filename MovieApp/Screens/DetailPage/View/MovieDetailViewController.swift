//
//  MovieDetailController.swift
//  MovieApp
//
//  Created by Eda Barutçu on 11.11.2023.
//

import UIKit

protocol MovieDetailViewControllerInterface: AnyObject {
    var viewModel: MovieDetailViewModelInterface? {get set}
    var imdbId: String? {get set}
    
    func setupUI()
    func updateUI()
    func showIndicator()
    func hideIndicator()
}

class MovieDetailViewController: UIViewController, MovieDetailViewControllerInterface {
    
    var viewModel: MovieDetailViewModelInterface?
    
    var imdbId: String?
    
    var activityIndicator: UIActivityIndicatorView!
    
    private lazy var movieImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleToFill
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 10
        return image
    }()
    
    private lazy var movieTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor(named: "Gray90")
        return label
    }()
    
    private lazy var movieDetailText: UILabel = {
        let label = UILabel()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        let attributedText = NSAttributedString(
            string: "",
            attributes: [.paragraphStyle: paragraphStyle]
        )
        label.attributedText = attributedText
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.textColor = UIColor(named: "Gray80")
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MovieDetailViewModel()
        viewModel?.view = self
        viewModel?.viewDidLoad()
    }
    
    func setupUI() {
        view.backgroundColor = UIColor(named: "Background10")
        self.navigationController?.navigationBar.tintColor = UIColor(named: "Gray90")
        navigationController?.title = "Movie Detail"
        
        view.addSubview(movieImage)
        view.addSubview(movieTitle)
        view.addSubview(movieDetailText)
        
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = UIColor(named: "Gray90") // Set your desired color
        activityIndicator.hidesWhenStopped = true
        
        // Add the activity indicator to the view
        view.addSubview(activityIndicator)
        
        // Set the constraints for the activity indicator (adjust as needed)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        movieImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(400)
        }
        
        movieTitle.snp.makeConstraints { make in
            make.top.equalTo(movieImage.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(44)
        }
        
        movieDetailText.snp.makeConstraints { make in
            make.top.equalTo(movieTitle.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-40)
            
        }
        
    }
    
    func updateUI() {
        
        DispatchQueue.main.async {
            // Load image asynchronously from the provided URL string
            if let url = URL(string: self.viewModel?.detailData?.Poster ?? "") {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.movieImage.image = image
                        }
                    }
                }.resume()
            } else {
                // If the URL is invalid, set a placeholder image or handle it accordingly
                self.movieImage.image = UIImage(named: "tshirt1")
            }
            
            // Set other properties
            self.movieTitle.text = self.viewModel?.detailData?.Title
            self.movieDetailText.text = "\(self.viewModel?.detailData?.Plot ?? "") \n\nGenre: \(self.viewModel?.detailData?.Genre ?? "") \nDirector: \(self.viewModel?.detailData?.Director ?? "") \nWriter: \(self.viewModel?.detailData?.Writer ?? "") \nActors: \(self.viewModel?.detailData?.Actors ?? "") \nIMDB Rating: \(self.viewModel?.detailData?.imdbRating ?? "")"
        }
    }
    
    func showIndicator() {
        self.activityIndicator.startAnimating()
    }
    
    func hideIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
        
    }
}
