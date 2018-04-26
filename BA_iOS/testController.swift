import Foundation
import UIKit

class testController: UIViewController {
    var itemToEdit: Event?
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = itemToEdit{
            self.title = item.name
        }
    }
}

