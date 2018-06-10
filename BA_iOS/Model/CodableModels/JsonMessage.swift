import Foundation

final public class JsonMessage: Codable {
    var id: Int
    var title: String
    var content: String
    var created: Date
    var scheduleId: String
    
    init(id: Int, title: String, content: String, created: Date, scheduleId: String) {
        self.id = id 
        self.title = title
        self.content = content
        self.created = created
        self.scheduleId = scheduleId
    }
}
