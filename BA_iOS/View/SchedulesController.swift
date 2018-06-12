import UIKit
import CoreData

class SchedulesController: UITableViewController, SegueHandler {
    
    var managedObjectContext: NSManagedObjectContext!
    fileprivate var dataSource: TableViewDataSource<SchedulesController>!
    fileprivate var observer: ManagedObjectObserver?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if managedObjectContext == nil {
            managedObjectContext = (self.tabBarController as! TabBarController).managedObjectContext
        }
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.topItem?.title = "Schedules"
        setupTableView()
    }
    
    enum SegueIdentifier: String {
        case showScheduleDetail = "showScheduleDetail"
        case showScanner = "showScanner"
    }

    func setupTableView() {
        
        let request = Schedule.sortedFetchRequest
        request.fetchBatchSize = 20
        request.returnsObjectsAsFaults = false
        let schedules = try! managedObjectContext.fetch(request)
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        dataSource = TableViewDataSource(tableView: tableView, cellIdentifier: "ScheduleCell", fetchedResultsController: frc, delegate: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segueIdentifier(for: segue) {
        case .showScheduleDetail:
            guard let vc = segue.destination as? ScheduleDetailController else { fatalError("Wrong view controller type") }
            guard let schedule = dataSource.selectedObject else { fatalError("Showing detail, but no selected row?") }
            vc.schedule = schedule
        case .showScanner:
            guard let scanner = segue.destination as? ScannerController else { fatalError("Wrong view controller type") }

        }
    }
    
    @IBAction func unwind(_ seque: UIStoryboardSegue) {
        if let sourceVC = seque.source as? ScannerController {
            if let id = sourceVC.qrCode {
                print(id)
                loadEntities(ofScheudle: id)
            }
        }
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
    
}

extension SchedulesController: TableViewDataSourceDelegate {
    func configure(_ cell: ScheduleTableViewCell, for object: Schedule) {
        //guard let schedule = object as? LocalizedStringConvertible else { fatalError("Wrong object type") }
        cell.configure(for: object)
    }
}

struct loadAndStoreConfiguration {
    let context: NSManagedObjectContext
    let group = DispatchGroup()
    let session = URLSession.shared
}
