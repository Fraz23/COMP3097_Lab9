//
//  COMP3097_Lab9App.swift
//  COMP3097 Lab9
//
//  Created by Faraz on 2026-03-30.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "COMP3097_Lab9")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved Core Data error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let navController = storyboard.instantiateInitialViewController() as? UINavigationController else {
            return false
        }

        if let addTaskViewController = navController.topViewController as? AddTaskViewController {
            addTaskViewController.viewContext = persistentContainer.viewContext
        }

        let window = UIWindow()
        window.rootViewController = navController
        window.makeKeyAndVisible()
        self.window = window

        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        saveContext()
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved Core Data error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
