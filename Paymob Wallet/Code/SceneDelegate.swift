//
//  SceneDelegate.swift
//  Paymob Wallet
//
//  Created by mohamed albohy on 5/11/20.
//  Copyright © 2020 mahmoud. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        
        
        
        
        
        guard let hardScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: hardScene)
        print("\n\n\n\n\n\n\n\n\n\n\n\n")
        print("this is Secene Delegate ")
        print(self.window)
        print("\n\n\n\n\n\n\n\n\n\n\n\n")
//        _ = AuthRouter()
        self.window?.rootViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "SplashVC") as! SplashVC
        self.window?.makeKeyAndVisible()
        
//        window = UIWindow()
        
    }

    @available(iOS 13.0, *)
    func sceneDidDisconnect(_ scene: UIScene) {}

    @available(iOS 13.0, *)
    func sceneDidBecomeActive(_ scene: UIScene) {}

    @available(iOS 13.0, *)
    func sceneWillResignActive(_ scene: UIScene) {}

    @available(iOS 13.0, *)
    func sceneWillEnterForeground(_ scene: UIScene) {}

    @available(iOS 13.0, *)
    func sceneDidEnterBackground(_ scene: UIScene) {}


}
