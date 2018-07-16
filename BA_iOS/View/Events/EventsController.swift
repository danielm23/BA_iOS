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
    
    var managedObjectContext: NSManagedObjectContext!
    var syncContext: NSManagedObjectContext?

    
    var activeSchedules: NSPredicate? = nil
    var favoriteEvents: NSPredicate? = nil
    var activeCategories: NSPredicate? = nil
    var predicates: [NSPredicate] = []
    var schedulePredicate: NSCompoundPredicate? = nil
    
    var refresh: UIRefreshControl?


    @IBAction func segmentedControllerChange(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 1:
            predicates = [activeSchedules ,favoriteEvents] as! [NSPredicate]
        default:
            predicates = [activeSchedules] as! [NSPredicate]
        }
        setupTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("did load")
        
        self.navigationController?.navigationBar.topItem?.title = "Nachrichten"


        if managedObjectContext == nil {
            managedObjectContext = (self.tabBarController as! TabBarController).managedObjectContext
        }
        if syncContext == nil {
            syncContext = (self.tabBarController as! TabBarController).syncContext
        }
        
        managedObjectContext?.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        syncContext?.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        syncContext?.addContextDidSaveNotificationObserver { [weak self] note in
            self?.managedObjectContext.performMergeChanges(from: note)
        }
        
        activeSchedules = NSPredicate(format: "%K == %@", "schedule.isActive", NSNumber(value: true))
        favoriteEvents = NSPredicate(format: "isFavorite == %@", NSNumber(value: true))
        activeCategories = NSPredicate(format: "ANY categories.isActive == true || categories.@count = 0")
        print(activeCategories)
        
        predicates = [activeSchedules, activeCategories] as! [NSPredicate]
        
        refresh = UIRefreshControl()
        refresh?.addTarget(self, action:  #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refresh?.attributedTitle = NSAttributedString(string: "Lade Updates ...")
        eventsTableView.refreshControl = refresh!
        
        setupTableView()
        //dataSource.updateFetch()
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        print("refresh")
        
        var config = LoadAndStoreConfiguration()
        config.set(syncContext: managedObjectContext)
        config.set(mainContext: syncContext!)
        
        let schedules = getSchedules(from: config.syncContext!)
        
        for schedule in schedules! {
            
            Schedule.loadAndStore(identifiedBy: schedule.id, config: config)
            Venue.loadAndStore(identifiedBy: schedule.id, config: config)
            Track.loadAndStore(identifiedBy: schedule.id, config: config)
            Message.loadAndStore(identifiedBy: schedule.id, config: config)
            Category.loadAndStore(identifiedBy: schedule.id, config: config)
            
            config.group.notify(queue: .main) {
                print("end 1")
                print("load events now")
                Event.loadAndStore(identifiedBy: schedule.id, config: config)
                config.mainContext?.delayedSaveOrRollback(group: config.group)
                config.group.notify(queue: .main) {
                    print("end 2")
                    self.refresh?.endRefreshing()
                }
            }
        }
    }
    
    func getSchedules(from context: NSManagedObjectContext) -> [Schedule]? {
        let request = Schedule.sortedFetchRequest
        request.returnsObjectsAsFaults = false
        let schedules = try! context.fetch(request)
        
        return schedules
    }
    
    func loadMessages() {
        let tbc = self.tabBarController as! TabBarController
        tbc.loadAndCountMessages()
    }

    fileprivate func setupTableView() {
        schedulePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        print(schedulePredicate)
        let request = Event.sortedFetchRequest(with: schedulePredicate!)
        request.fetchBatchSize = 20
        request.returnsObjectsAsFaults = false
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: "startDate", cacheName: nil)
        dataSource = TableViewDataSource(tableView: eventsTableView, cellIdentifier: "Cell", fetchedResultsController: frc, delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("did appear")
        setupTableView()
        loadMessages()

        
        do {
            //try dataSource.fetchedResultsController.performFetch()
            print("update")
            
        } catch { fatalError("fetch request failed") }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segueIdentifier(for: segue) {
        case .showEventDetail:
            guard let vc = segue.destination as? EventDetailController else { fatalError("Wrong view controller type") }
            guard let event = dataSource.selectedObject else { fatalError("Showing detail, but no selected row?") }
            //vc.managedObjectContext = managedObjectContext
            vc.event = event
        case .showFilter:
            guard let vc = segue.destination as? NewFilterController else { fatalError("Wrong view controller type") }
            //vc.managedObjectContext = managedObjectContext
        }
    }
}

extension EventsController: TableViewDataSourceDelegate {
    func configure(_ cell: EventTableViewCell, for object: Event) {
            cell.configure(for: object)
    }
}

