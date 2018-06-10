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
    @NSManaged fileprivate(set) var schedule: Schedule?
    @NSManaged fileprivate(set) var events: Set<Event>?
    
    var geoinformation: JsonGeoinformation?
    var geolocation: JsonGeolocation?
    
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
    
    static func insert(into context: NSManagedObjectContext, json: JsonVenue) -> Venue {
        let venue: Venue = context.insertObject()
        venue.id = Int32(json.id)
        venue.name = json.name
        venue.geoinformationId = json.geoinformationId
        
        let schedulePredicate = NSPredicate(format: "%K == %@", #keyPath(id), json.scheduleId)
        venue.schedule = Schedule.findOrFetch(in: context, matching: schedulePredicate)
        
        return venue
    }

    static func loadAndStore(identifiedBy scheduleId: String, config: LoadAndStoreConfiguration) {
        config.group.enter()
        Webservice().load(resource: JsonSchedule.getVenues(of: scheduleId), session: config.session) { venues in for venue in venues! {
                config.context.performChanges {
                    let _ = Venue.insert(into: config.context, json: venue)
                }
            }
            config.group.leave()
        }
    }
}
