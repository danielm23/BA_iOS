import Foundation
import CoreData

class Event: Codable {
    var id: Int
    var name: String
    var info: String
    var startDate: Date
    var endDate: Date
    var isActive: Bool
    var scheduleId: String
    var venueId: Int
    
    init(id: Int, name: String, info: String, startDate: Date, endDate: Date,
         isActive: Bool, scheduleId: String, venueId: Int) {
        self.id = id
        self.name = name
        self.info = info
        self.startDate = startDate
        self.endDate = endDate
        self.isActive = isActive
        self.scheduleId = scheduleId
        self.venueId = venueId
    }
}
