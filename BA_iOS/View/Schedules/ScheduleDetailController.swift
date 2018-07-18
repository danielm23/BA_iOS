import Foundation
import UIKit
import CoreData

class ScheduleDetailController: UIViewController {
    
    var managedObjectContext: NSManagedObjectContext!
    fileprivate var observer: ManagedObjectObserver?
    @IBOutlet weak var label: UILabel!
    
    @IBAction func deleteButtonClicked(_ sender: Any) {
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
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.title = schedule.name
    }
}
