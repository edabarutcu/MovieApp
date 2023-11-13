//
//  SplashController.swift
//  MovieApp
//
//  Created by Eda Barutçu on 11.11.2023.
//

import UIKit
import SnapKit

class SplashController: UIViewController {
    
    private lazy var appName: UILabel = {
        let label = UILabel()
        label.text = "Movie App"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = UIColor(named: "Gray20")
        return label
    }()
    
    private lazy var movieImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleToFill
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 10
        image.image = UIImage(named: "movie")
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = UIColor.black
        let initialAlpha: CGFloat = 0.0
        movieImage.alpha = initialAlpha
        view.addSubview(movieImage)
        movieImage.snp.makeConstraints { make in
            make.height.width.equalTo(200)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        UIView.animate(withDuration: 3.0, delay: 0.2, options: .curveEaseInOut, animations: { [weak self] in
            self?.movieImage.alpha = 1.0
        })
    }
}
