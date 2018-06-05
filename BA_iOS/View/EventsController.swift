import UIKit
import Foundation
//import RxSwift
//import RxCocoa
import CoreData

class EventsController: UIViewController, SegueHandler {
    
    enum SegueIdentifier: String {
        case showEventDetail = "showEventDetail"
        case showScanner = "showScanner"
        case showSchedules = "showSchedules"
    }
    
    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    fileprivate var dataSource: TableViewDataSource<EventsController>!
    fileprivate var observer: ManagedObjectObserver?
    
    var managedObjectContext: NSManagedObjectContext!
    
    var activeSchedules: NSPredicate? = nil
    var favoriteEvents: NSPredicate? = nil
    var predicates: [NSPredicate] = []
    var schedulePredicate: NSCompoundPredicate? = nil

    
    @IBAction func segmentedControllerChange(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 1:
            predicates = [activeSchedules, favoriteEvents] as! [NSPredicate]
        default:
            predicates = [activeSchedules] as! [NSPredicate]
        }
        setupTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(tabBarController?.selectedIndex)
        activeSchedules = NSPredicate(format: "%K == %@", "schedule.isActive", NSNumber(value: true))
        favoriteEvents = NSPredicate(format: "isFavorite == %@", NSNumber(value: true))
        setupTableView()
    }


    
    fileprivate func setupTableView() {
        var request = NSFetchRequest<Event>()
        schedulePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request = Event.sortedFetchRequest(with: schedulePredicate!)
        request.fetchBatchSize = 20
        request.returnsObjectsAsFaults = false
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: "startDate", cacheName: nil)
        dataSource = TableViewDataSource(tableView: eventsTableView, cellIdentifier: "Cell", fetchedResultsController: frc, delegate: self)
    }
    
    /*fileprivate func updateDataSource() {
        dataSource.reconfigureFetchRequest { request in
            //let regionType = filterSegmentedControl.regionType
            //request.entity = regionType.entity
            //request.sortDescriptors = regionType.defaultSortDescriptors
        }
    }*/
    
    override func viewDidAppear(_ animated: Bool) {
        setupTableView()
    }
    
    func loadEventsOfSchedule(qrcode: String) {
        
        // ALLWAYS USE TUNNEL
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        Webservice().load(resource: JsonSchedule.get(id: qrcode)) { schedule in
            self.managedObjectContext.performChanges {
                let _ = Schedule.insert(into: self.managedObjectContext, json: schedule!)
                print("inserted schedule " + (schedule?.name)!)
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        print("inserted venues: ")
        Webservice().load(resource: JsonSchedule.getVenues(of: qrcode)) { venues in
            for venue in venues! {
                self.managedObjectContext.performChanges {
                    let _ = Venue.insert(into: self.managedObjectContext, json: venue)
                }
            }
            dispatchGroup.leave()
        }
        
        print(" ")
        print("inserted events: ")
        dispatchGroup.notify(queue: .main) {
            Webservice().load(resource: JsonSchedule.getEvents(of: qrcode)) { events in
                for event in events! {
                    self.managedObjectContext.performChanges {
                        let _ = Event.insert(into: self.managedObjectContext, json: event)
                        print(event.name ?? "no name")
                    }
                }
            }
        }
        print(" ")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segueIdentifier(for: segue) {
        case .showEventDetail:
            guard let vc = segue.destination as? EventDetailController else { fatalError("Wrong view controller type") }
            guard let event = dataSource.selectedObject else { fatalError("Showing detail, but no selected row?") }
            vc.managedObjectContext = managedObjectContext
            vc.event = event
        case .showScanner:
            guard let scanner = segue.destination as? ScannerController else { fatalError("Wrong view controller type") }
        case .showSchedules:
            guard let vc = segue.destination as? SchedulesController else { fatalError("Wrong view controller type") }
            vc.managedObjectContext = managedObjectContext
        }
    }
    
    @IBAction func unwind(_ seque: UIStoryboardSegue) {
        let dispatchGroup = DispatchGroup()
        if let sourceVC = seque.source as? ScannerController {
            dispatchGroup.enter()
            loadEventsOfSchedule(qrcode: sourceVC.qrCode!)
        }

    }
}

extension EventsController: TableViewDataSourceDelegate {
    func configure(_ cell: EventTableViewCell, for object: Event) {
            cell.configure(for: object)
    }
}
