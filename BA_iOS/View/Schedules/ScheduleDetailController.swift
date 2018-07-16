import Foundation
import UIKit
import CoreData
import Down

class ScheduleDetailController: UIViewController {
    
    var managedObjectContext: NSManagedObjectContext!
    
    fileprivate var observer: ManagedObjectObserver?
    
    @IBOutlet weak var label: UILabel!
    
    @IBAction func deleteButtonClicked(_ sender: Any) {
        print("deleteButton clicked")
        print(schedule.name)
        
        schedule.managedObjectContext?.performChanges {
            self.managedObjectContext?.delete(self.schedule)
        }
    }
    
    @objc var schedule: Schedule! {
        didSet {
            observer = ManagedObjectObserver(object: schedule) { [unowned self] type in
                guard type == .delete else { return }
                _ = self.navigationController?.popViewController(animated: true)
            }
            // updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never

        self.title = schedule.name
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    @IBAction func updateButtonClicked(_ sender: Any) {
        var config = LoadAndStoreConfiguration()
        config.mainContext = managedObjectContext
        
        let version = schedule.getVersion(config: config)
    }
}
