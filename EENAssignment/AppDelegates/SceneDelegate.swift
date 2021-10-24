//
//  SceneDelegate.swift
//  EENAssignment
//
//  Created by Ruchira Macbook on 2021-10-08.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let aScene = (scene as? UIWindowScene) else { return }
        let aWindow = UIWindow(windowScene: aScene)
        let rootViewController = Factory.createLoginScreen()
        let navController = UINavigationController(rootViewController: rootViewController)
        aWindow.rootViewController = navController
        
        if AppDataManager.shared.hasTokens() {
            AppDataManager.shared.loadSavedTokensToMemory()
            let homeViewController = Factory.createHomeViewController()
            navController.pushViewController(homeViewController, animated: false)
        }
        
        self.window = aWindow
        self.window?.makeKeyAndVisible()
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

