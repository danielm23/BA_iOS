import Foundation
import CoreData

public class Event: NSManagedObject {
    
    // general info
    @NSManaged fileprivate(set) var id: Int32
    @NSManaged fileprivate(set) var name: String
    @NSManaged fileprivate(set) var info: String?
    
    // status info
    @NSManaged fileprivate(set) var isActive: Bool
    @NSManaged fileprivate(set) var isFavorite: Bool
    
    // dates
    @NSManaged fileprivate(set) var startDate: Date
    @NSManaged fileprivate(set) var endDate: Date
    
    // relationships
    @NSManaged public fileprivate(set) var schedule: Schedule?
    @NSManaged fileprivate(set) var venue: Venue?

    
    public static func insert(into context: NSManagedObjectContext, json: JsonEvent) -> Event {
        let event: Event = context.insertObject()
        
        event.id = Int32(json.id)
        event.info = json.info
        event.name = json.name
        event.isActive = json.isActive
        event.isFavorite = json.isFavorite
        event.startDate = json.startDate
        event.endDate = json.endDate
        //event.schedule = Schedule.findOrCreate(for: json.scheduleId, in: context)
        //event.venue = Venue.findOrCreate(for: json.venueId, in: context)
        
        return event
    }

}

extension Event: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(startDate), ascending: false)]
    }
}
