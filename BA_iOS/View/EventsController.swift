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
        print("set moc1")
        if managedObjectContext == nil {
            managedObjectContext = (self.tabBarController as! TabBarController).managedObjectContext
        }
        print("set moc2")

        activeSchedules = NSPredicate(format: "%K == %@", "schedule.isActive", NSNumber(value: true))
        favoriteEvents = NSPredicate(format: "isFavorite == %@", NSNumber(value: true))
        predicates = [activeSchedules] as! [NSPredicate]
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
    
    
    override func viewDidAppear(_ animated: Bool) {
        print("did appear")
        setupTableView()
    }
    
    func loadEntities(ofScheudle id: String) {
        
        // ALLWAYS USE LOCALHOST TUNNEL WHILE DEVELOPMENT
        
        let loadConfig = LoadAndStoreConfiguration(context: managedObjectContext)
        print("before schedule")
        Schedule.loadAndStore(identifiedBy: id, config: loadConfig)
        print("after schedule")
        Venue.loadAndStore(identifiedBy: id, config: loadConfig)
        print("after venue")
        Track.loadAndStore(identifiedBy: id, config: loadConfig)
        print("after track")
        Message.loadAndStore(identifiedBy: id, config: loadConfig)
        print("after message")
        Category.loadAndStore(identifiedBy: id, config: loadConfig)
        print("after categories")
        loadConfig.group.notify(queue: .main) {
            print("before events")
            Event.loadAndStore(identifiedBy: id, config: loadConfig)
            print("after events")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segueIdentifier(for: segue) {
        case .showEventDetail:
            guard let vc = segue.destination as? EventDetailController else { fatalError("Wrong view controller type") }
            guard let event = dataSource.selectedObject else { fatalError("Showing detail, but no selected row?") }
            //vc.managedObjectContext = managedObjectContext
            vc.event = event
        case .showScanner:
            guard let scanner = segue.destination as? ScannerController else { fatalError("Wrong view controller type") }
        case .showSchedules:
            guard let vc = segue.destination as? SchedulesController else { fatalError("Wrong view controller type") }
            vc.managedObjectContext = managedObjectContext
        }
    }
    
    @IBAction func unwind(_ seque: UIStoryboardSegue) {
        if let sourceVC = seque.source as? ScannerController {
            loadEntities(ofScheudle: sourceVC.qrCode!)
        }
    }
}

extension EventsController: TableViewDataSourceDelegate {
    func configure(_ cell: EventTableViewCell, for object: Event) {
            cell.configure(for: object)
    }
}

struct loadAndStoreConfiguration {
    let context: NSManagedObjectContext
    let group = DispatchGroup()
    let session = URLSession.shared
}
