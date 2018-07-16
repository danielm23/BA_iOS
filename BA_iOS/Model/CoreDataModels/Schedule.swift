import Foundation
import CoreData

@objc(Schedule)
public class Schedule: NSManagedObject {
    
    // general info
    @NSManaged fileprivate(set) var id: String
    @NSManaged fileprivate(set) var name: String
    @NSManaged fileprivate(set) var info: String?
    
    // status info
    @NSManaged fileprivate(set) var version: Int32
    @NSManaged fileprivate(set) var isActive: Bool

    // dates
    @NSManaged fileprivate(set) var startDate: Date?
    @NSManaged fileprivate(set) var endDate: Date?
    
    // relationships
    @NSManaged fileprivate(set) var events: Set<Event>?
    @NSManaged fileprivate(set) var venues: Set<Venue>?
    @NSManaged fileprivate(set) var messages: Set<Message>?
    @NSManaged fileprivate(set) var categories: Set<Category>?
    @NSManaged fileprivate(set) var tracks: Set<Track>?

    /*
    static func findOrCreate(for scheduleId: String, in context: NSManagedObjectContext) -> Schedule {
        let predicate = NSPredicate(format: "%K == %@", #keyPath(id), scheduleId)
        let schedule = findOrCreate(in: context, matching: predicate) {
            $0.id = scheduleId
        }
        return schedule
    }*/
    
    public func setActive() {
        isActive = !isActive
        print(isActive)
    }
}

extension Schedule: Managed {
    static var entityName: String {
        return "Schedule"
    }
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(startDate), ascending: false)]
    }
    
    static func insert(into context: NSManagedObjectContext, json: JsonSchedule) -> Schedule {
        let schedule: Schedule = context.insertObject()
        
        schedule.id = json.id
        schedule.name = json.name
        schedule.info = json.info
        schedule.version = Int32(json.version)
        schedule.isActive = true
        schedule.startDate = json.startDate
        schedule.endDate = json.endDate
        //schedule.events = Event.findOrCreate(for: json.scheduleId, in: context)
        //schedule.venues = Venue.findOrCreate(for: json.venueId, in: context)
        
        return schedule
    }
}

extension Schedule {
    static func loadAndStore(identifiedBy scheduleId: String, config: LoadAndStoreConfiguration) {
        config.group.enter()
        Webservice().load(resource: JsonSchedule.get(scheduleId), session: config.session) { schedule in
            config.mainContext?.performChanges {
                let _ = Schedule.insert(into: config.mainContext!, json: schedule!)
                print(schedule?.name)
            }
            config.group.leave()
        }
    }
    
    func getVersion(config: LoadAndStoreConfiguration) {
        var newSchedule: JsonSchedule?
        
        config.group.enter()
        Webservice().load(resource: JsonSchedule.get(id), session: config.session) { schedule in
            newSchedule = schedule
            config.group.leave()
        }
        
        config.group.notify(queue: .main) {
            let versionsEqual = newSchedule?.version == Int(self.version)
            print(newSchedule?.version)
            print(self.version)
            
            print(versionsEqual)
            
            if !versionsEqual {
                config.mainContext?.performChanges {
                    config.mainContext?.delete(self)
                    print("deleted")
                }
                //self.performUpdate(of: newSchedule!, loadConfig: config)
            }
            else {
                print("no update available")
            }
        }
    }
    
    func performUpdate(of schedule: JsonSchedule, loadConfig: LoadAndStoreConfiguration){
        print("perform update")
        id = schedule.id
        print(id)
        
        
        //Schedule.loadAndStore(identifiedBy: id, config: loadConfig)
        //Venue.loadAndStore(identifiedBy: id, config: loadConfig)
        //Track.loadAndStore(identifiedBy: id, config: loadConfig)
        //Message.loadAndStore(identifiedBy: id, config: loadConfig)
        //Category.loadAndStore(identifiedBy: id, config: loadConfig)
        
        //loadConfig.group.notify(queue: .main) {
            //loadConfig.group.enter()
            //Event.loadAndStore(identifiedBy: self.id, config: loadConfig)
            //loadConfig.group.leave()
            //loadConfig.group.notify(queue: .main) {
                //print("update finished")
            //}
        //}
    }

}
