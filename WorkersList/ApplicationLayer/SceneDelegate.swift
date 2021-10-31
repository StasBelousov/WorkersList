//
//  SceneDelegate.swift
//  WorkersList
//
//  Created by Станислав Белоусов on 30.10.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = MainViewController()
       
        self.window = window
       // window = UIWindow(frame:UIScreen.main.bounds)
        window.makeKeyAndVisible()
    }

}

