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
    
    
    public static func insert(into context: NSManagedObjectContext, json: JsonEvent) -> Event {
        let event: Event = context.insertObject()
        
        event.id = Int32(json.id)
        event.info = json.info
        event.name = json.name
        event.isActive = true
        event.isFavorite = true
        event.startDate = json.startDate
        event.endDate = json.endDate
        
        let schedulePredicate = NSPredicate(format: "%K == %@", #keyPath(id), json.scheduleId)
        event.schedule = Schedule.findOrFetch(in: context, matching: schedulePredicate)
        
        let venuePredicate = NSPredicate(format: "%K == %ld", #keyPath(id), json.venueId)
        event.venue = Venue.findOrFetch(in: context, matching: venuePredicate)
        
        return event
    }

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
}

