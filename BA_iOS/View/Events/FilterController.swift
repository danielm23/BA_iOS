import UIKit
import CoreData

class FilterController: UITableViewController {

    var managedObjectContext: NSManagedObjectContext!
    var rightItem = UIBarButtonItem()
    let favoriteButton: UIButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    fileprivate var dataSource: TableViewDataSource<FilterController>!
    
    fileprivate func setupTableView() {
        
        let request = Schedule.sortedFetchRequest
        request.fetchBatchSize = 20
        request.returnsObjectsAsFaults = false
        
        //let schedules = try! managedObjectContext.fetch(request)
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        dataSource = TableViewDataSource(tableView: tableView, cellIdentifier: "ScheduleFilterCell", fetchedResultsController: frc, delegate: self)
    }
}

extension FilterController: TableViewDataSourceDelegate {
    func configure(_ cell: ScheduleFilterTableViewCell, for object: Schedule) {
        //guard let schedule = object as? LocalizedStringConvertible else { fatalError("Wrong object type") }
        cell.configure(withSchedule: object)
    }
    
    override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        do {
            dataSource.selectedObject?.setActive()
            try managedObjectContext.save()
            tableView.reloadData()
            print("saved")
        } catch {
            fatalError("error setting active")
        }
    }
}
