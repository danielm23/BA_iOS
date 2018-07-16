import Foundation

public class JsonSchedule: Codable {
    
    var id: String
    var name: String
    var info: String
    
    var startDate: Date
    var endDate: Date
    
    var isPublic: Bool?
    var version: Int
    
    init(id: String, name: String, info: String, startDate: Date,
         endDate: Date, isPublic: Bool, version: Int) {
        
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
    
    static func get(_ id: String) -> Resource<JsonSchedule> {
        return Resource<JsonSchedule>(url: "schedules/\(id)")
    }
    
    static func getVenues(of schedule: String) -> Resource<[JsonVenue]> {
        return Resource<[JsonVenue]>(url: "schedules/\(schedule)/venues")
    }
    
    static func getEvents(of schedule: String) -> Resource<[JsonEvent]> {
        return Resource<[JsonEvent]>(url: "schedules/\(schedule)/events")
    }
    
    static func getTracks(of schedule: String) -> Resource<[JsonTrack]> {
        return Resource<[JsonTrack]>(url: "schedules/\(schedule)/tracks")
    }
    
    static func getMessages(of schedule: String) -> Resource<[JsonMessage]> {
        return Resource<[JsonMessage]>(url: "schedules/\(schedule)/messages")
    }
    
    static func getCategories(of schedule: String) -> Resource<[JsonCategory]> {
        return Resource<[JsonCategory]>(url: "schedules/\(schedule)/categories")
    }
}
