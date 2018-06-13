import UIKit
import Foundation
import CoreData


class MessagesController: UITableViewController {
    
    var managedObjectContext: NSManagedObjectContext!
    fileprivate var dataSource: TableViewDataSource<MessagesController>!
    fileprivate var observer: ManagedObjectObserver?

    override func viewDidLoad() {
        super.viewDidLoad()
        if managedObjectContext == nil {
            managedObjectContext = (self.tabBarController as! TabBarController).managedObjectContext
        }
        setupTableView()
    }
    
    func setupTableView() {
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let request = Message.sortedFetchRequest
        request.fetchBatchSize = 20
        request.returnsObjectsAsFaults = false
        let messages = try! managedObjectContext.fetch(request)
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        dataSource = TableViewDataSource(tableView: tableView, cellIdentifier: "MessageCell", fetchedResultsController: frc, delegate: self)
    }
}

extension MessagesController: TableViewDataSourceDelegate {
    func configure(_ cell: MessageTableViewCell, for object: Message) {
        cell.configure(for: object)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}
