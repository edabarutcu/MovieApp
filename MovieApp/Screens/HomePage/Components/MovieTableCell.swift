//
//  MovieCell.swift
//  MovieApp
//
//  Created by Eda Barutçu on 11.11.2023.
//

import UIKit
import SnapKit

class MovieTableCell: UITableViewCell {
    private lazy var movieImage = UIImageView()
    private lazy var movieDetailText = UILabel()
    private lazy var movieName = UILabel()
    private lazy var movieView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
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
            make.height.equalTo(120)
            make.width.equalToSuperview()
        }
        
        movieView.addSubview(movieImage)
        movieImage.clipsToBounds = true
        movieImage.contentMode = .scaleToFill
        movieImage.layer.masksToBounds = true
        movieImage.layer.cornerRadius = 10
        movieImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.width.height.equalTo(104)
            make.leading.equalToSuperview().offset(8)
        }
        
        movieView.addSubview(movieName)
        movieName.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        movieName.textColor = UIColor(named: "Gray90")
        movieName.numberOfLines = 0
        movieName.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.height.equalTo(40)
            make.leading.equalTo(movieImage.snp.trailing).offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        movieView.addSubview(movieDetailText)
        movieDetailText.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        movieDetailText.textColor = UIColor(named: "Gray80")
        movieDetailText.numberOfLines = 0
        movieDetailText.snp.makeConstraints { make in
            make.top.equalTo(movieName.snp.bottom).offset(8)
            make.height.equalTo(40)
            make.leading.equalTo(movieName)
            make.trailing.equalToSuperview().offset(-12)
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
