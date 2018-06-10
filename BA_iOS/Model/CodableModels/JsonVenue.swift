import Foundation

public class JsonVenue: Codable {
    var id: Int32
    var name: String
    
    var scheduleId: String
    var geoinformationId: Int32
    
    init(id: Int32, name: String, scheduleId: String, geoinformationId: Int32) {
        self.id = id
        self.name = name
        self.scheduleId = scheduleId
        self.geoinformationId = geoinformationId
    }
}
