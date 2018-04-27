import Foundation
import UIKit
import RxSwift
import RxCocoa

class EventDetailController: UIViewController {
    
    var eventDetailViewModel = EventDetailViewModel()
    var disposeBag = DisposeBag()

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    
    @IBAction func button(_ sender: Any) {
        eventDetailViewModel.addEvents(newFavorite: eventDetailViewModel.event, orderNumber: 1)
        button.setTitle("Is Favorite", for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = eventDetailViewModel.event.name
        if eventDetailViewModel.eventIsFavorite() {
            button.setTitle("Is Favorite", for: .normal)
        }
        else {
            button.setTitle("Add to favorites", for: .normal)
        }
    }
}
