 //
//  AppDelegate.swift
//  coreDate
//
//  Created by Daniel Müller on 12.04.18.
//  Copyright © 2018 Daniel Müller. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {
    
    var window: UIWindow?
    var persistentContainer: NSPersistentContainer!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        createCDContainer { container in
            self.persistentContainer = container
            //container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
            
            
            let storyboard = self.window?.rootViewController?.storyboard
            guard let tabBarController = storyboard?.instantiateViewController(withIdentifier: "TabBarController")
                as? TabBarController else {
                    fatalError("Cannot instantiate root view controller")
                }
            tabBarController.delegate = self
            tabBarController.selectedIndex = 1
            
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            tabBarController.managedObjectContext = container.viewContext
            tabBarController.syncContext = container.newBackgroundContext()
            tabBarController.syncContext?.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            self.window?.rootViewController = tabBarController
        }
        return true
    }
}
