import UIKit
import RxSwift
import RxCocoa

class EventsController: UIViewController {
    
    //var valueToPass: String?
    
    @IBOutlet weak var eventsTableView: UITableView!
    
    var eventsViewModel = EventsViewModel()
    var disposeBag = DisposeBag()
    
    let dispatchGroup = DispatchGroup()
    
    let passDetail = "fromTable"
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        populateEventsTableView()
        subscribeSelectedEvent()
        
        
        
        //var indexPathEvent = eventsTableView.indexPathForSelectedRow!
        //var selectedEvent = eventsTableView.cellForRow(at: indexPathEvent) as! EventTableViewCell
        //valueToPass = selectedEvent.title.text!
        
        // https://stackoverflow.com/questions/46811630/get-model-from-uicollectionview-indexpath
        //let x = eventsTableView.rx.modelSelected(PersistantEvent.self).asObservable()
        /*eventsTableView
            .rx
            .modelSelected(PersistantEvent.self)
            //.asObservable()
            //.map { $0 }
            //.bind(to:label.text)
            //.disposed(by:self.disposeBag)
            .subscribe(onNext: { (item) in
                self.eventsViewModel.itemSelected = item
                //print(self.eventsViewModel.itemSelected)
            }).disposed(by: disposeBag)
        //label.text = y*/
    }
    
    
    private func populateEventsTableView() {
        let observableEvents = eventsViewModel.getEvents().asObservable()
            
        observableEvents.bind(to: eventsTableView.rx.items(cellIdentifier: "Cell", cellType: EventTableViewCell.self)) { (row, element, cell) in
                cell.configure(item: element)
                print(element)
            }
            .disposed(by: disposeBag)
    }
    
    private func subscribeSelectedEvent() {
        eventsTableView
            .rx
            .modelSelected(PersistantEvent.self)
            
            .subscribe(onNext: { (event) in
                self.eventsViewModel.itemSelected = event
                //print(self.eventsViewModel.itemSelected)
            }).disposed(by: disposeBag)
     
        /*eventsTableView.rx.modelSelected(PersistantEvent.self)
            .bind(to: eventsViewModel.selectedItem)
            .disposed(by: disposeBag)*/
    }
    
    @IBAction func unwind(_ seque: UIStoryboardSegue) {
        if let sourceVC = seque.source as? ScannerController {
            dispatchGroup.enter()
            eventsViewModel.addEvents(withQrCode: sourceVC.qrCode!)
        }
    }
     /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if let indexPath = eventsTableView.indexPathForSelectedRow{
            let selectedRow = indexPath.row
            let detailVC = segue.destination as! EventDetailController
            detailVC.item = "xx"
        
    }
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewDetails" {
            let detailVC = segue.destination as! EventDetailController
            //let selectedItem = eventsTableView.rx.modelSelected(PersistantEvent.self)
            print(eventsViewModel.itemSelected)
            detailVC.eventDetailViewModel.event = eventsViewModel.itemSelected
            //let detailVC = segue.destination as! EventDetailController
            //detailVC.item = passDetail
        }
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewDetails" {
            let detailVC = segue.destination as! EventDetailController
            detailVC.eventDetailViewModel.event = eventsViewModel.selectedItem
            
            print("eventsViewModel.selectedItem: ")
            print(eventsViewModel.selectedItem)
            //detailVC.eventDetailViewModel.event = eventsViewModel.itemSelected
        }
    }*/
}
