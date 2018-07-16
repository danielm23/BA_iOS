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
    @NSManaged fileprivate(set) var location: GeoOverview?
    @NSManaged fileprivate(set) var events: Set<Event>?
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
        
        //let locationPredicate = NSPredicate(format: "%K == %@", #keyPath(id), json.geoinformationId)
        //venue.location = GeoOverview.findOrFetch(in: context, matching: locationPredicate)

        return venue
    }

    static func loadAndStore(identifiedBy scheduleId: String, config: LoadAndStoreConfiguration) {
        config.group.enter()
        Webservice().load(resource: JsonSchedule.getVenues(of: scheduleId), session: config.session) { venues in for venue in venues! {
            config.mainContext?.performChanges {
                let _ = Venue.insert(into: config.mainContext!, json: venue)
                print(venue.name)
                }
            }
            config.group.leave()
        }
    }
}
