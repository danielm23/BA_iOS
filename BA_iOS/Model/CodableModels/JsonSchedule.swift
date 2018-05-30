import Foundation
import CoreData

public class JsonSchedule: Codable {
    
    var id: String
    var name: String
    var info: String
    
    var startDate: Date
    var endDate: Date
    
    var isPublic: Bool?
    var version: Int?
    
    init(id: String,
         name: String,
         info: String,
         startDate: Date,
         endDate: Date,
         isPublic: Bool,
         version: Int) {
        
        self.id = id
        self.name = name
        self.info = info
        self.startDate = startDate
        self.endDate = endDate
        self.isPublic = isPublic
        self.version = version
    }
}

extension JsonSchedule {
    
    static func get(id: String) -> Resource<JsonSchedule> {
        return Resource<JsonSchedule>(url: "schedules/" + id)
    }
    
    static func getVenues(of schedule: String) -> Resource<[JsonVenue]> {
        return Resource<[JsonVenue]>(url: "schedules/" + schedule + "/venues")
    }
    
    func getVenues() -> Resource<[JsonVenue]> {
        return Resource<[JsonVenue]>(url: "schedules/" + id + "/venues")
    }
    
    static func getEvents(of schedule: String) -> Resource<[JsonEvent]> {
        return Resource<[JsonEvent]>(url: "schedules/" + schedule + "/events")
    }
    
    func getEvents() -> Resource<[JsonEvent]> {
        return Resource<[JsonEvent]>(url: "schedules/" + id + "/events")
    }
}
