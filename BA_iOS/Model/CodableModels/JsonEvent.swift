import Foundation

public class JsonEvent: Codable {
    var id: Int32?
    var name: String?
    var info: String?
    
    var startDate: Date?
    var endDate: Date?
    
    var isActive: Bool?
    var isFavorite: Bool?
    
    var scheduleId: String
    var venueId: Int?
    var trackId: Int?
    
    init(id: Int32, name: String, info: String, startDate: Date, endDate: Date,
         isActive: Bool, isFavorite: Bool, scheduleId: String, venueId: Int, trackId: Int) {
        self.id = id
        self.name = name
        self.info = info
        self.startDate = startDate
        self.endDate = endDate
        self.isActive = isActive
        self.isFavorite = isFavorite
        self.scheduleId = scheduleId
        self.venueId = venueId
        self.trackId = trackId
    }
}

extension JsonEvent {
    static func getCategories(of eventId: Int32) -> Resource<[JsonCategory]> {
        return Resource<[JsonCategory]>(url: "events/\(eventId)/categories")
    }
}


