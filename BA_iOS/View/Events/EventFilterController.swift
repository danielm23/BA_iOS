import Foundation
import UIKit
import CoreData

class EventFilterController: UITableViewController {
    
    var managedObjectContext: NSManagedObjectContext!
    var schedules: [Schedule]?
    var categories: [Category]? = []
    
    private enum Section: Int {
        case schedule, category
        static var numberOfSections: Int { return 2 }
        
        init?(indexPath: NSIndexPath) {
            self.init(rawValue: indexPath.section)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if managedObjectContext == nil {
            managedObjectContext = (self.tabBarController as! TabBarController).managedObjectContext
        }
        loadSchedules()
        loadCategories()
    }
    
    func loadSchedules() {
        let scheduleRequest = Schedule.sortedFetchRequest
        scheduleRequest.fetchBatchSize = 20
        scheduleRequest.returnsObjectsAsFaults = false
        schedules = try! managedObjectContext.fetch(scheduleRequest)
    }
    
    func loadCategories() {
        let categoryRequest = Category.sortedFetchRequest
        categoryRequest.fetchBatchSize = 20
        categoryRequest.returnsObjectsAsFaults = false
        categories = try! managedObjectContext.fetch(categoryRequest)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleFilterCell") as? ScheduleFilterTableViewCell
        
        switch Section(indexPath: indexPath as NSIndexPath) {
        case .schedule?: cell?.configure(withSchedule: schedules![indexPath.row])
        case .category?: cell?.configure(withCategory: categories![indexPath.row])
        case .none: break
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .schedule?: return (schedules?.count)!
        case .category?: return (categories?.count)!
        case .none: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Section(rawValue: section) {
        case .schedule?: return "Veranstaltungen"
        case .category?: return "Kategorien"
        case .none: return nil
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let dispatchGroup = DispatchGroup()
        switch Section(indexPath: indexPath as NSIndexPath) {
        case .schedule?:
            dispatchGroup.enter()
            managedObjectContext.performChanges {
                self.schedules![indexPath.row].setActive()
                dispatchGroup.leave()
            }
            dispatchGroup.notify(queue: .main) {
                tableView.reloadData()
            }
        case .category?:
            dispatchGroup.enter()
            managedObjectContext.performChanges {
                self.categories![indexPath.row].setActive()
                dispatchGroup.leave()
            }
            dispatchGroup.notify(queue: .main) {
                tableView.reloadData()
            }
            
        case .none: break
        }
    }
}
