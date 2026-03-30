//
//  SceneDelegate.swift
//  COMP3097 Lab9
//

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let navController = storyboard.instantiateInitialViewController() as? UINavigationController else {
            return
        }

        if let addTaskViewController = navController.topViewController as? AddTaskViewController,
           let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            addTaskViewController.viewContext = appDelegate.persistentContainer.viewContext
        }

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navController
        self.window = window
        window.makeKeyAndVisible()
    }
}
