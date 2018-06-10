import Foundation

final class JsonTrack: Codable {
    var id: Int
    var title: String
    var scheduleId: String
    
    init(id: Int, title: String, scheduleId: String) {
        self.id = id 
        self.title = title
        self.scheduleId = scheduleId
    }
}
