import UIKit
import Foundation
import CoreData

class EventsController: UIViewController, SegueHandler {
    
    enum SegueIdentifier: String {
        case showEventDetail = "showEventDetail"
        case showFilter = "showFilter"
    }
    
    // UI
    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var refresh: UIRefreshControl?
    
    // references
    fileprivate var dataSource: TableViewDataSource<EventsController>!
    var managedObjectContext: NSManagedObjectContext!
    var syncContext: NSManagedObjectContext?

    // filter predicates
    var activeSchedules: NSPredicate? = nil
    var favoriteEvents: NSPredicate? = nil
    var activeCategories: NSPredicate? = nil
    var predicates: [NSPredicate] = []
    var schedulePredicate: NSCompoundPredicate? = nil
    
    
    @IBAction func segmentedControllerChange(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 1: predicates = [activeSchedules ,favoriteEvents] as! [NSPredicate]
        default: predicates = [activeSchedules] as! [NSPredicate]
        }
        configureTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "Nachrichten"
        configureContexts()
        configurePredicates()
        configurePullToRefresh()
        configureTableView()
    }
    
    func configureContexts() {
        if managedObjectContext == nil {
            managedObjectContext = (self.tabBarController as! TabBarController).managedObjectContext
            managedObjectContext?.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        }
        if syncContext == nil {
            syncContext = (self.tabBarController as! TabBarController).syncContext
            syncContext?.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        }
        syncContext?.addContextDidSaveNotificationObserver { [weak self] note in
            self?.managedObjectContext.performMergeChanges(from: note)
        }
    }
    
    fileprivate func configurePredicates() {
        activeSchedules = NSPredicate(format: "%K == %@", "schedule.isActive", NSNumber(value: true))
        favoriteEvents = NSPredicate(format: "isFavorite == %@", NSNumber(value: true))
        activeCategories = NSPredicate(format: "ANY categories.isActive == true || categories.@count = 0")
        predicates = [activeSchedules, activeCategories] as! [NSPredicate]
    }
    
    fileprivate func configurePullToRefresh() {
        refresh = UIRefreshControl()
        refresh?.addTarget(self, action:  #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refresh?.attributedTitle = NSAttributedString(string: "Lade Updates ...")
        eventsTableView.refreshControl = refresh!
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        var config = LoadAndStoreConfiguration()
        config.set(syncContext: managedObjectContext)
        config.set(mainContext: syncContext!)
        checkForUpdate(config: config)
    }
    
    func checkForUpdate(config: LoadAndStoreConfiguration) {
        let schedules = Schedule.loadCurrentSchedules(from: config.syncContext!)
        
        for schedule in schedules! {
            var newSchedule: JsonSchedule?
            
            config.group.enter()
            Webservice().load(resource: JsonSchedule.get(schedule.id),
                              session: config.session) { schedule in
                newSchedule = schedule
                config.group.leave()
            }
            
            config.group.notify(queue: .main) {
                let versionsEqual = newSchedule?.version == Int(schedule.version)
                print("new: ")
                print(newSchedule?.version)
                print("current: ")
                print(schedule.version)
                print(versionsEqual)
                
                switch !versionsEqual {
                    case true: print("update available")
                    case false: print("no update available")
                }
            }
        }
    }

    func performUpdate(config: LoadAndStoreConfiguration, scheduleId: String) {
        
        Schedule.loadAndStore(identifiedBy: scheduleId, config: config)
        Venue.loadAndStore(identifiedBy: scheduleId, config: config)
        Track.loadAndStore(identifiedBy: scheduleId, config: config)
        Message.loadAndStore(identifiedBy: scheduleId, config: config)
        Category.loadAndStore(identifiedBy: scheduleId, config: config)
        
        config.group.notify(queue: .main) {
            Event.loadAndStore(identifiedBy: scheduleId, config: config)
            config.mainContext?.delayedSaveOrRollback(group: config.group)
            config.group.notify(queue: .main) {
                self.refresh?.endRefreshing()
            }
        }
    }

    func loadMessages() {
        let tabBarController = self.tabBarController as! TabBarController
        tabBarController.loadAndCountMessages()
    }

    fileprivate func configureTableView() {
        schedulePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        let request = Event.sortedFetchRequest(with: schedulePredicate!)
        request.fetchBatchSize = 20
        request.returnsObjectsAsFaults = false
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: "startDate", cacheName: nil)
        dataSource = TableViewDataSource(tableView: eventsTableView, cellIdentifier: "Cell", fetchedResultsController: frc, delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureTableView()
        loadMessages()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segueIdentifier(for: segue) {
        case .showEventDetail:
            guard let vc = segue.destination as? EventDetailController else { fatalError("Wrong view controller type") }
            guard let event = dataSource.selectedObject else { fatalError("Showing detail, but no selected row?") }
            vc.event = event
        case .showFilter:
            guard let vc = segue.destination as? NewFilterController else { fatalError("Wrong view controller type") }
        }
    }
}

extension EventsController: TableViewDataSourceDelegate {
    func configure(_ cell: EventTableViewCell, for object: Event) {
            cell.configure(for: object)
    }
}
