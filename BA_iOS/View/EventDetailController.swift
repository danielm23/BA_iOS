import Foundation
import UIKit
import RxSwift
import RxCocoa

class EventDetailController: UIViewController {
    
    var eventDetailViewModel = EventDetailViewModel()
    var disposeBag = DisposeBag()

    @IBOutlet weak var label: UILabel!
    
    @IBAction func button(_ sender: Any) {
        print("buttonpressed")
        eventDetailViewModel.addEvents(newFavorite: eventDetailViewModel.event, orderNumber: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = eventDetailViewModel.event.name
    }
}
