//
//  MovieCollectionCell.swift
//  MovieApp
//
//  Created by Eda Barutçu on 11.11.2023.
//

import UIKit
import SnapKit

class MovieCollectionCell: UICollectionViewCell {
    private lazy var movieImage = UIImageView()
    private lazy var movieDetailText = UILabel()
    private lazy var movieName = UILabel()
    private lazy var movieView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        contentView.backgroundColor = UIColor(named: "Background10")
        
        contentView.addSubview(movieView)
        movieView.layer.borderWidth = 1
        movieView.clipsToBounds = true
        movieView.layer.cornerRadius = 12
        movieView.backgroundColor = UIColor.white
        movieView.layer.borderColor = UIColor(named: "Gray50")?.cgColor
        movieView.snp.makeConstraints { make in
            make.height.width.equalTo(180)
        }
        
        movieView.addSubview(movieImage)
        movieImage.clipsToBounds = true
        movieImage.contentMode = .scaleToFill
        movieImage.layer.masksToBounds = true
        movieImage.layer.cornerRadius = 10
        movieImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.width.height.equalTo(164)
            make.leading.equalToSuperview().offset(8)
        }
        
    }
    
    public func configure(movieUrl: String,
                          movieDetailText: String,
                          movieName: String
    ) {
        DispatchQueue.main.async {
            // Load image asynchronously from the provided URL string
            if let url = URL(string: movieUrl) {
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
            self.movieDetailText.text = movieDetailText
            self.movieName.text = movieName
        }
    }
}

