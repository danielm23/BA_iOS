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
}

extension Event: Managed {

    static var entityName: String {
        return "Event"
    }
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(startDate), ascending: true)]
    }
    
    internal static func insert(into context: NSManagedObjectContext, json: JsonEvent) -> Event {
        let event: Event = context.insertObject()
        
        event.id = json.id!
        event.info = json.info
        event.name = json.name
        event.isActive = true
        event.isFavorite = false
        event.startDate = json.startDate
        event.endDate = json.endDate
        
        let schedulePredicate = NSPredicate(format: "%K == %@", #keyPath(id), json.scheduleId)
        event.schedule = Schedule.findOrFetch(in: context, matching: schedulePredicate)
        
        if (json.venueId != nil){
            print("set venue")
            let venuePredicate = NSPredicate(format: "%K == %ld", #keyPath(id), json.venueId!)
            event.venue = Venue.findOrFetch(in: context, matching: venuePredicate)
            print(event.venue?.name)
        }
        
        if (json.trackId != nil) {
            print("set track")
            let trackPredicate = NSPredicate(format: "%K == %ld", #keyPath(id), json.trackId!)
            event.track = Track.findOrFetch(in: context, matching: trackPredicate)
            print(event.track?.title)
        }
        
        // set categories
        let config = LoadAndStoreConfiguration(context: context)

        Webservice().load(resource: JsonEvent.getCategories(of: event.id), session: config.session) { categories in for category in categories! {
                //print(category.id)
                let categoryPredicate = NSPredicate(format: "%K == %ld", #keyPath(id), category.id)
                let newCategory = Category.findOrFetch(in: context, matching: categoryPredicate)
                print("new category: ")
                print(newCategory)
                let x = event.categories?.insert(newCategory!)
                print(x)
            }
        }
        print("inserted: ")
        print(event)
        return event
    }
    
    static func loadAndStore(identifiedBy scheduleId: String, config: LoadAndStoreConfiguration) {
        Webservice().load(resource: JsonSchedule.getEvents(of: scheduleId), session: config.session) { events in
            for event in events! {
                config.context.performChanges {
                    let _ = Event.insert(into: config.context, json: event)
                }
            }
        }
    }
}
