import Foundation
import CoreData

public class Schedule: NSManagedObject {
    
    // general info
    @NSManaged fileprivate(set) var id: Int32
    @NSManaged fileprivate(set) var name: String
    @NSManaged fileprivate(set) var info: String?
    
    // status info
    @NSManaged fileprivate(set) var version: Int32
    
    // dates
    @NSManaged fileprivate(set) var startDate: Date?
    @NSManaged fileprivate(set) var endDate: Date?
    
    // relationships
    @NSManaged fileprivate(set) var events: Set<Event>?
    @NSManaged fileprivate(set) var venues: Set<Venue>?
}

extension Schedule: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(startDate), ascending: false)]
    }
}
