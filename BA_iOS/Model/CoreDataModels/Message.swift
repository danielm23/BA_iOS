import Foundation
import CoreData

@objc(Message)
public class Message: NSManagedObject {
    
    @NSManaged fileprivate(set) var id: Int32
    @NSManaged fileprivate(set) var title: String
    @NSManaged fileprivate(set) var content: String
    
     @NSManaged fileprivate(set) var isNew: Bool
    
    @NSManaged fileprivate(set) var created: Date
    
    @NSManaged public fileprivate(set) var schedule: Schedule?
}

extension Message {
    func setAsViewed() {
        isNew = false
    }
}

extension Message: Managed {

    static var entityName: String {
        return "Message"
    }
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(created), ascending: false)]
    }
    
    static func insert(into context: NSManagedObjectContext, json: JsonMessage) -> Message {
        let message: Message = context.insertObject()
        
        message.id = Int32(json.id)
        message.title = json.title
        message.content = json.content
        message.created = json.created
        message.isNew = true

        let schedulePredicate = NSPredicate(format: "%K == %@", #keyPath(id), json.scheduleId)
        message.schedule = Schedule.findOrFetch(in: context, matching: schedulePredicate)
        
        return message
    }

    static func loadAndStore(identifiedBy scheduleId: String, config: LoadAndStoreConfiguration) {
        config.group.enter()
        print("load messages")
        Webservice().load(resource: JsonSchedule.getMessages(of: scheduleId), session: config.session) { messages in
            for message in messages! {
                
                print(message.title)
                config.mainContext?.performChanges {
                    let _ = Message.insert(into: config.mainContext!, json: message)
                }
            }
        config.group.leave()
        }
    }
}
