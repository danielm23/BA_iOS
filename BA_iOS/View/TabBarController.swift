//
// https://makeapppie.com/2015/02/04/swift-swift-tutorials-passing-data-in-tab-bar-controllers/
//

import Foundation
import UIKit
import CoreData

class TabBarController: UITabBarController {
    
    var managedObjectContext: NSManagedObjectContext?
    var syncContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        syncContext?.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        syncContext?.name = "SyncCoordinator"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        loadAndCountMessages()
    }
    
    func loadAndCountMessages() {
        loadMessages()
        countMessages()
    }
    
    func getMessages(from context: NSManagedObjectContext) -> [Message]? {
        let activeSchedules = NSPredicate(format: "%K == %@", "schedule.isActive", NSNumber(value: true))
        let request = Message.sortedFetchRequest(with: activeSchedules)
        request.returnsObjectsAsFaults = true
        let loadedMessages = try! context.fetch(request)
        return loadedMessages
    }
    
    func getSchedules(from context: NSManagedObjectContext) -> [Schedule]? {
        let request = Schedule.sortedFetchRequest
        request.returnsObjectsAsFaults = false
        let schedules = try! context.fetch(request)
        
        return schedules
    }
    
    public func countMessages() {

        let activeSchedules = NSPredicate(format: "%K == %@", "schedule.isActive", NSNumber(value: true))
        let newMessages = NSPredicate(format: "isNew == %@", NSNumber(value: true))
        let predicates = [activeSchedules, newMessages] 
        let messagePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        let request = Message.sortedFetchRequest(with: messagePredicate)
        request.returnsObjectsAsFaults = true
        let loadedMessages = try! managedObjectContext?.fetch(request)
        let numberOfNewMessages = loadedMessages?.count
        if numberOfNewMessages == 0 {
            childViewControllers[3].tabBarItem.badgeValue = nil
        } else {
            childViewControllers[3].tabBarItem.badgeValue = String(numberOfNewMessages!)
        }
    }
    
    func loadMessages() {
        var config = LoadAndStoreConfiguration()
        config.set(mainContext: managedObjectContext!)
        config.set(syncContext: syncContext!)
        
        var insertedMessageIds = Set<Int>()
        var currentMessageIds = Set<Int>()
        
        let currentMessages = getMessages(from: config.mainContext!)
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
            let deleted = currentMessageIds.subtracting(insertedMessageIds)
            
            for msgId in deleted {
                let msgPredicate = NSPredicate(format: "%K == %d", "id", Int32(msgId))
                let msg = Message.findOrFetch(in: config.mainContext!, matching: msgPredicate)
                
                config.mainContext!.performChanges {
                    config.mainContext!.delete(msg!)
                }
                
            }
        }
    }
}


