import Foundation
import UIKit

class EventDetailController: UIViewController {
    var itemToEdit: Event?
    
    
    @IBOutlet weak var label: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // navigationController?.navigationBar.item
        if let item = itemToEdit{
            self.title = item.name
            //label.text = item.name
        }
    }
}
