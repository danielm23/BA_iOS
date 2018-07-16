import Foundation
import CoreData

@objc(Track)
public class Track: NSManagedObject {
    
    @NSManaged fileprivate(set) var id: Int32
    @NSManaged fileprivate(set) var title: String
    
    @NSManaged public fileprivate(set) var schedule: Schedule?
    @NSManaged fileprivate(set) var events: Set<Event>?

    
}

extension Track: Managed {
    
    static var entityName: String {
        return "Track"
    }
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(title), ascending: true)]
    }
    
    static func insert(into context: NSManagedObjectContext, json: JsonTrack) -> Track {
        let track: Track = context.insertObject()
        
        track.id = Int32(json.id)
        track.title = json.title

        let schedulePredicate = NSPredicate(format: "%K == %@", #keyPath(id), json.scheduleId)
        track.schedule = Schedule.findOrFetch(in: context, matching: schedulePredicate)
        
        return track
    }
    
    static func loadAndStore(identifiedBy scheduleId: String, config: LoadAndStoreConfiguration) {
        print("load tracks")
        Webservice().load(resource: JsonSchedule.getTracks(of: scheduleId), session: config.session) { tracks in
            for track in tracks! {
                print(track)
                config.mainContext?.performChanges {
                    let _ = Track.insert(into: config.mainContext!, json: track)
                }
            }
        }
    }
}
