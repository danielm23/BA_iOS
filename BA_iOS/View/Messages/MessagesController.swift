import UIKit
import Foundation
import CoreData


class MessagesController: UITableViewController {
    
    var managedObjectContext: NSManagedObjectContext!
    var syncContext: NSManagedObjectContext?
    
    fileprivate var dataSource: TableViewDataSource<MessagesController>!
    fileprivate var observer: ManagedObjectObserver?
    
    var refresh: UIRefreshControl?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureContexts()
        configurePullToRefresh()
        self.title = "Nachrichten"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        configureTableView()
        markAsViewed()
        self.tabBarController?.childViewControllers[3].tabBarItem.badgeValue = nil
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
    
    fileprivate func configurePullToRefresh() {
        refresh = UIRefreshControl()
        refresh?.addTarget(self, action:  #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refresh?.attributedTitle = NSAttributedString(string: "Lade neue Nachrichten ...")
        self.tableView.refreshControl = refresh!
    }
    
    func markAsViewed() {
        let currentMessages = dataSource.fetchedResultsController.fetchedObjects
        for message in currentMessages! {
            managedObjectContext.performChanges {
                message.setAsViewed()
            }
        }
    }
    
    func configureTableView() {
        let activeSchedules = NSPredicate(format: "%K == %@", "schedule.isActive", NSNumber(value: true))
        let request = Message.sortedFetchRequest(with: activeSchedules)
        request.fetchBatchSize = 20
        request.returnsObjectsAsFaults = false

        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: managedObjectContext,
                                             sectionNameKeyPath: nil, cacheName: nil)
        dataSource = TableViewDataSource(tableView: tableView, cellIdentifier: "MessageCell",
                                         fetchedResultsController: frc, delegate: self)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        var config = LoadAndStoreConfiguration()
        config.set(mainContext: managedObjectContext)
        config.set(syncContext: syncContext!)
        
        var insertedMessageIds = Set<Int>()
        var currentMessageIds = Set<Int>()
        let currentMessages = dataSource.fetchedResultsController.fetchedObjects
        let currentSchedules = getSchedules(from: config.mainContext!)

        for msg in currentMessages! {
            currentMessageIds.insert(Int(msg.id))
        }
        
        for schedule in currentSchedules! {
            config.group.enter()
            Webservice().load(resource: JsonSchedule.getMessages(of: schedule.id),
                              session: config.session) { messages in
                for message in messages! {
                    insertedMessageIds.insert(message.id)
                    let _ = Message.insert(into: config.syncContext!, json: message)
                    config.syncContext?.delayedSaveOrRollback(group: config.group)
                }
                config.group.leave()
            }
        }
        
        config.group.notify(queue: .main) {
            let deletedMessages = currentMessageIds.subtracting(insertedMessageIds)
           
            for messageId in deletedMessages {
                let messagePredicate = NSPredicate(format: "%K == %d", "id", Int32(messageId))
                let messageToDelete = Message.findOrFetch(in: config.mainContext!, matching: messagePredicate)

                config.mainContext!.performChanges {
                    config.mainContext!.delete(messageToDelete!)
                }
            }
            self.refresh?.endRefreshing()
        }
    }

    func getSchedules(from context: NSManagedObjectContext) -> [Schedule]? {
        let request = Schedule.sortedFetchRequest
        request.returnsObjectsAsFaults = false
        let schedules = try! context.fetch(request)
        
        return schedules
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
