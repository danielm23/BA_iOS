import Foundation
import UIKit
import RxSwift
import RxCocoa

class EventDetailController: UIViewController {
    
    var eventDetailViewModel = EventDetailViewModel()
    var disposeBag = DisposeBag()

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    /*
    @IBAction func button(_ sender: Any) {
        eventDetailViewModel.addEvents(newFavorite: eventDetailViewModel.event, orderNumber: 1)
        button.setTitle(eventDetailViewModel.getButtonText(), for: .normal)
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(eventDetailViewModel.event)
        
        //let event = eventDetailViewModel.event.asObservable()
        
        label.text = ""
        print("set Text")
        label.text = eventDetailViewModel.event.name
        //note: replace with rxswift implementation
        //button.setTitle(eventDetailViewModel.getButtonText(), for: .normal)
    }
}
