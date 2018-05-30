import UIKit
import CoreData

class SchedulesController: UITableViewController {

    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    
    fileprivate var dataSource: TableViewDataSource<SchedulesController>!
    
    fileprivate func setupTableView() {
        
        let request = Schedule.sortedFetchRequest
        request.fetchBatchSize = 20
        request.returnsObjectsAsFaults = false
        let schedules = try! managedObjectContext.fetch(request)
        print(schedules)
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        dataSource = TableViewDataSource(tableView: tableView, cellIdentifier: "ScheduleCell", fetchedResultsController: frc, delegate: self)
    }
}

extension SchedulesController: TableViewDataSourceDelegate {
    func configure(_ cell: ScheduleTableViewCell, for object: Schedule) {
        //guard let schedule = object as? LocalizedStringConvertible else { fatalError("Wrong object type") }
        cell.configure(for: object)
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
