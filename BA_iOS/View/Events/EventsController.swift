import UIKit
import Foundation
//import RxSwift
//import RxCocoa
import CoreData

class EventsController: UIViewController, SegueHandler {
    
    enum SegueIdentifier: String {
        case showEventDetail = "showEventDetail"
        case showFilter = "showFilter"
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
        if managedObjectContext == nil {
            managedObjectContext = (self.tabBarController as! TabBarController).managedObjectContext
        }
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
        super.viewDidAppear(animated)
        print("did appear")
        setupTableView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segueIdentifier(for: segue) {
        case .showEventDetail:
            guard let vc = segue.destination as? EventDetailController else { fatalError("Wrong view controller type") }
            guard let event = dataSource.selectedObject else { fatalError("Showing detail, but no selected row?") }
            //vc.managedObjectContext = managedObjectContext
            vc.event = event
        case .showFilter:
            guard let vc = segue.destination as? FilterController else { fatalError("Wrong view controller type") }
            vc.managedObjectContext = managedObjectContext
        }
    }
}

extension EventsController: TableViewDataSourceDelegate {
    func configure(_ cell: EventTableViewCell, for object: Event) {
            cell.configure(for: object)
    }
}

