import UIKit
import CoreData

class SchedulesController: UITableViewController {

    var managedObjectContext: NSManagedObjectContext!
    var rightItem = UIBarButtonItem()
    let favoriteButton: UIButton = UIButton(type: .custom)
    
    @IBAction func infoButtonPressed(_ sender: Any) {
        print("pressed")
        let destViewController = storyboard?.instantiateViewController(withIdentifier: "InformationController") as! InformationController
        destViewController.managedObjectContext = managedObjectContext
        self.show(destViewController, sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        configureButton()
    }
    
    fileprivate var dataSource: TableViewDataSource<SchedulesController>!
    
    fileprivate func setupTableView() {
        
        let request = Schedule.sortedFetchRequest
        request.fetchBatchSize = 20
        request.returnsObjectsAsFaults = false
        let schedules = try! managedObjectContext.fetch(request)
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        dataSource = TableViewDataSource(tableView: tableView, cellIdentifier: "ScheduleCell", fetchedResultsController: frc, delegate: self)
    }
    
    fileprivate func configureButton() {
        favoriteButton.setImage(UIImage(named: "Favorite"), for: .normal)
        favoriteButton.addTarget(self, action: #selector(self.infoButtonPressed(_:)), for: .touchUpInside)
        rightItem = UIBarButtonItem(customView: favoriteButton)
        self.navigationItem.rightBarButtonItem = rightItem
        print("set button")
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
