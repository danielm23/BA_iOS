import Foundation
import CoreData

public class Venue: NSManagedObject {
    
    // general info
    @NSManaged fileprivate(set) var id: Int32
    @NSManaged fileprivate(set) var name: String
    
    // geo info
    @NSManaged fileprivate(set) var geoinformationId: String?
    
    // relationships
    @NSManaged fileprivate(set) var schedules: Set<Schedule>?
    @NSManaged fileprivate(set) var events: Set<Event>?
    
    static func findOrCreate(for venueId: Int, in context: NSManagedObjectContext) -> Venue {
        let predicate = NSPredicate(format: "%K == %ld", #keyPath(id), venueId)
        let venue = findOrCreate(in: context, matching: predicate) {
            $0.id = Int32(venueId)
            $0.name = "Default Text"
        }
        return venue
    }
}

extension Venue: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(name), ascending: false)]
    }
}
