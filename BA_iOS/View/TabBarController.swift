//
// https://makeapppie.com/2015/02/04/swift-swift-tutorials-passing-data-in-tab-bar-controllers/
//

import Foundation
import UIKit
import CoreData

class TabBarController: UITabBarController {
    var managedObjectContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        childViewControllers[3].tabBarItem.badgeValue = "20"
    }
}