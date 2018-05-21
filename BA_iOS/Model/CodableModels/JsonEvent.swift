import Foundation
import CoreData

public class JsonEvent: Codable {
    var id: Int
    var name: String
    var info: String
    
    var startDate: Date
    var endDate: Date
    
    var isActive: Bool
    var isFavorite: Bool
    
    var scheduleId: String
    var venueId: Int
    
    init(id: Int, name: String, info: String, startDate: Date, endDate: Date,
         isActive: Bool, isFavorite: Bool, scheduleId: String, venueId: Int) {
        self.id = id
        self.name = name
        self.info = info
        self.startDate = startDate
        self.endDate = endDate
        self.isActive = isActive
        self.isFavorite = isFavorite
        self.scheduleId = scheduleId
        self.venueId = venueId
    }
}
