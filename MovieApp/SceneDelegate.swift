//
//  SceneDelegate.swift
//  MovieApp
//
//  Created by Eda Barutçu on 11.11.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        let splashVC = SplashController()
        window?.rootViewController = splashVC
        window?.makeKeyAndVisible()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            let movieHomeVC = MovieHomeViewController()
            let navigationController = UINavigationController(rootViewController: movieHomeVC)
            self.window?.rootViewController = navigationController
        }
    }
}

