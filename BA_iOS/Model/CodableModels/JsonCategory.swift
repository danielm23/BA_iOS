import Foundation

//typealias RGB = Int32

final class JsonCategory: Codable {
    var id: Int
    var name: String
    var color: Int64
    var scheduleId: String
    
    init(id: Int, name: String, color: Int64, scheduleId: String) {
        self.id = id
        self.name = name
        self.color = color
        self.scheduleId = scheduleId
    }
}
