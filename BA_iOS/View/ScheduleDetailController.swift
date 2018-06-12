import Foundation
import UIKit
import CoreData
import Down

class ScheduleDetailController: UIViewController {
    
    var managedObjectContext: NSManagedObjectContext!
    
    fileprivate var observer: ManagedObjectObserver?
    
    @objc var schedule: Schedule! {
        didSet {
            observer = ManagedObjectObserver(object: schedule) { [unowned self] type in
                guard type == .update else { return }
                //let _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managedObjectContext = (self.tabBarController as! TabBarController).managedObjectContext
        
        guard let downView = try? DownView(frame: self.view.bounds, markdownString: schedule.info!, didLoadSuccessfully: {
            // Optional callback for loading finished
            print("Markdown was rendered.")
        }) else { return }
        view.addSubview(downView)
    }
    
    fileprivate let markdownString = """
    # Down
    Test

    #### Maintainers
    
    - [Rob Phillips](https://github.com/iwasrobbed)
    - [Keaton Burleson](https://github.com/128keaton)
    - [Other contributors](https://github.com/iwasrobbed/Down/graphs/contributors) 🙌
    
    ### Installation
    
    Note: Swift 4 support is now on the `master` branch and any tag >= 0.4.x (Swift 3 is 0.3.x)
    
    Quickly install using [CocoaPods](https://cocoapods.org):
    
    ```ruby
    pod 'Down'
    ```
    
    Or [Carthage](https://github.com/Carthage/Carthage):
    
    ```
    github "iwasrobbed/Down"
    ```
    Due to limitations in Carthage regarding platform specification, you need to define the platform with Carthage.
    
    e.g.
    
    ```carthage update --platform iOS```
    
    Or manually install:
    
    1. Clone this repository
    2. Build the Down project
    3. Add the resulting framework file to your project
    4. ?
    5. Profit
    """
}
