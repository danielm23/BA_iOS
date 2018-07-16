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
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "TabBarController")
                as? TabBarController else {
                    fatalError("Cannot instantiate root view controller")
                }
            vc.delegate = self
            vc.selectedIndex = 1
            
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            vc.managedObjectContext = container.viewContext
            vc.syncContext = container.newBackgroundContext()
            vc.syncContext?.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            self.window?.rootViewController = vc
        }
        return true
    }
}
