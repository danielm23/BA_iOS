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
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never

        self.title = schedule.name
        self.navigationController?.navigationBar.prefersLargeTitles = false

        //self.navigationController?.navigationBar.topItem?.title = "abc"
        //navigationController?.navigationBar.topItem?.title = schedule.name
        
        guard let downView = try? DownView(frame: self.view.bounds, markdownString: schedule.info!, didLoadSuccessfully: {
            // Optional callback for loading finished
        }) else { return }
        //view.addSubview(downView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //self.navigationController?.navigationBar.prefersLargeTitles = false
    }
}
