import Foundation
import CoreData

@objc(Venue)
public class Venue: NSManagedObject {
    
    // general info
    @NSManaged fileprivate(set) var id: Int32
    @NSManaged fileprivate(set) var name: String
    
    // geo info
    @NSManaged fileprivate(set) var geoinformationId: Int32
    
    // relationships
    @NSManaged fileprivate(set) var schedules: Set<Schedule>?
    @NSManaged fileprivate(set) var events: Set<Event>?
    
    var geoinformation: JsonGeoinformation?
    var geolocation: JsonGeolocation?
    
    public static func insert(into context: NSManagedObjectContext, json: JsonVenue) -> Venue {
        let venue: Venue = context.insertObject()
        venue.id = Int32(json.id)
        venue.name = json.name
        venue.geoinformationId = json.geoinformationId
        
    return venue
    }
    
    public func setGeoinformation(info: JsonGeoinformation) {
        geoinformation = info
    }
    
    public func setGeolocation(location: JsonGeolocation) {
        geolocation = location
    }
}

extension Venue: Managed {
    static var entityName: String {
        return "Venue"
    }
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(name), ascending: false)]
    }
}
