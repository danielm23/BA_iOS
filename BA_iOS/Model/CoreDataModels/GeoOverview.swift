import Foundation
import CoreData

//@objc(GeoOverview)
public class GeoOverview: NSManagedObject {
    
    // general info
    @NSManaged var id: Int32
    @NSManaged var title: String
    
    // geo info
    @NSManaged var longitude: Double
    @NSManaged var latitude: Double
    
    // relationships
    @NSManaged var venues: Set<Venue>?
}

extension GeoOverview: Managed {
    
    static var entityName: String {
        return "GeoOverview"
    }
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(title), ascending: false)]
    }
    
    static func insert(into context: NSManagedObjectContext, json: JsonGeoOverview) -> GeoOverview {
        let overview: GeoOverview = context.insertObject()
        overview.id = Int32(json.id)
        overview.title = json.title
        if json.latitude == nil { overview.latitude = 0 } else { overview.latitude = json.latitude! }
        if json.longitude == nil { overview.longitude = 0 } else { overview.longitude = json.longitude! }
        
        return overview
    }
    
    static func loadAndStore(identifiedBy geoinformationId: Int32, config: LoadAndStoreConfiguration) {
        config.group.enter()
        Webservice().load(resource: JsonGeoOverview.get(of: geoinformationId),
                          session: config.session) { overview in
            config.context?.performChanges {
                let _ = GeoOverview.insert(into: config.context!, json: overview!)
            }
            config.group.leave()
        }
    }
}

extension GeoOverview: Encodable {
    enum CodingKeys: String, CodingKey {
        case id, title, longitude, latitude // no case for `venues`
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(longitude, forKey: .longitude)
        try container.encode(latitude, forKey: .latitude)
    }
}
