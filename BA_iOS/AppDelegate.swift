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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {print("entered createCDContainer")
        createCDContainer { container in
            self.persistentContainer = container
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            let storyboard = self.window?.rootViewController?.storyboard
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "TabBarController")
                as? TabBarController else {
                    fatalError("Cannot instantiate root view controller")
                }
            vc.delegate = self
            vc.selectedIndex = 1
            
            //let eventsVc = vc.childViewControllers[1].childViewControllers[0] as? EventsController
            //eventsVc?.managedObjectContext = container.viewContext
            vc.managedObjectContext = container.viewContext

            self.window?.rootViewController = vc
        }
        return true
    }
}
