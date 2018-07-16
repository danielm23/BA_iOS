import Foundation
import CoreData

@objc(Event)
public class Event: NSManagedObject {
    
    // general info
    @NSManaged fileprivate(set) var id: Int32
    @NSManaged fileprivate(set) var name: String?
    @NSManaged fileprivate(set) var info: String?
    
    // status info
    @NSManaged fileprivate(set) var isActive: Bool
    @NSManaged fileprivate(set) var isFavorite: Bool
    
    // dates
    @NSManaged fileprivate(set) var startDate: Date?
    @NSManaged fileprivate(set) var endDate: Date?
    
    // relationships
    @NSManaged public fileprivate(set) var schedule: Schedule?
    @NSManaged fileprivate(set) var venue: Venue?
    @NSManaged fileprivate(set) var track: Track?
    @NSManaged fileprivate(set) var categories: Set<Category>?

    public func switchFavoriteStatus() {
        isFavorite = !isFavorite
    }
    
    public var hasActiveCategories: Bool {
        if (categories?.isEmpty)! {
            return true
        }
        for category in categories! {
            if category.isActive {
                return true
            }
        }
        return false
    }
}

extension Event: Managed {

    static var entityName: String {
        return "Event"
    }
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(startDate), ascending: true)]
    }
    
    internal static func insert(into context: NSManagedObjectContext, json: JsonEvent) -> Event {
        
        var config = LoadAndStoreConfiguration()
        config.set(mainContext: context)
        
        let event: Event = context.insertObject()
        
        event.id = json.id!
        event.info = json.info
        event.name = json.name
        event.isActive = true
        event.isFavorite = false
        event.startDate = json.startDate
        event.endDate = json.endDate
        //context.delayedSaveOrRollback(group: config.group)
        print("EVENT: ")
        print(event)
        
        
        let schedulePredicate = NSPredicate(format: "%K == %@", #keyPath(id), json.scheduleId)
        event.schedule = Schedule.findOrFetch(in: context, matching: schedulePredicate)
        //context.delayedSaveOrRollback(group: config.group)

        
        if (json.venueId != nil){
            let venuePredicate = NSPredicate(format: "%K == %ld", #keyPath(id), json.venueId!)
            event.venue = Venue.findOrFetch(in: context, matching: venuePredicate)
            //context.delayedSaveOrRollback(group: config.group)
        }
        
        if (json.trackId != nil) {
            let trackPredicate = NSPredicate(format: "%K == %ld", #keyPath(id), json.trackId!)
            event.track = Track.findOrFetch(in: context, matching: trackPredicate)
            //context.delayedSaveOrRollback(group: config.group)
        }
        

        Webservice().load(resource: JsonEvent.getCategories(of: event.id), session: config.session) { categories in for category in categories! {
            let eventPredicate = NSPredicate(format: "%K == %ld", #keyPath(id), json.id!)
            let evt = Event.findOrFetch(in: context, matching: eventPredicate)
            
            
                print(evt)
                print("cat id: ")
                print(category.id)
                let categoryPredicate = NSPredicate(format: "%K == %ld", #keyPath(id), category.id)
                let newCategory = Category.findOrFetch(in: context, matching: categoryPredicate)
            
                print("old categories: ")
                print(event.categories)
                print("new category: ")
                print(newCategory)
                evt?.categories?.insert(newCategory!)
                context.delayedSaveOrRollback(group: config.group)
                //print(x)
            }
        }
        //print("inserted: ")
        //print(event)
        return event
    }
    
    static func loadAndStore(identifiedBy scheduleId: String, config: LoadAndStoreConfiguration) {
        config.group.enter()
        Webservice().load(resource: JsonSchedule.getEvents(of: scheduleId), session: config.session) { events in
            for event in events! {
                config.mainContext?.performChanges {
                    let _ = Event.insert(into: config.mainContext!, json: event)
                    print(event)
                }
            }
            config.group.leave()
        }
    }
}
