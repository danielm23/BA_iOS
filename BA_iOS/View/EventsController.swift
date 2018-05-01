import UIKit
import RxSwift
import RxCocoa

class EventsController: UIViewController {

    @IBOutlet weak var eventsTableView: UITableView!
    
    var eventsViewModel = EventsViewModel()
    var disposeBag = DisposeBag()
    let dispatchGroup = DispatchGroup()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        populateEventsTableView()
        setupTodoListTableViewCellWhenItemAccessoryButtonTapped()
    }
    
    private func setupTodoListTableViewCellWhenItemAccessoryButtonTapped() {
        eventsTableView.rx.itemAccessoryButtonTapped
            .subscribe(onNext : { indexPath in
                self.eventsViewModel.selectedEvent = self.eventsViewModel.getEvent(index: indexPath.row)
                self.switchVC()
            })
            .disposed(by: disposeBag)
    }
    
    private func populateEventsTableView() {
        let observableEvents = eventsViewModel.getEvents().asObservable()
            
        observableEvents.bind(to: eventsTableView.rx.items(cellIdentifier: "Cell", cellType: EventTableViewCell.self)) { (row, element, cell) in
                cell.configure(item: element)
                print(element)
            }
            .disposed(by: disposeBag)
    }
    
    func switchVC() {
        let destViewController = storyboard?.instantiateViewController(withIdentifier: "EventDetailController") as! EventDetailController
        destViewController.eventDetailViewModel.event = eventsViewModel.selectedEvent
        self.show(destViewController, sender: nil)
    }
  
    @IBAction func unwind(_ seque: UIStoryboardSegue) {
        if let sourceVC = seque.source as? ScannerController {
            dispatchGroup.enter()
            eventsViewModel.addEvents(withQrCode: sourceVC.qrCode!)
        }
    }
}
