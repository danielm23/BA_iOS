import Foundation

final public class JsonGeoinformation: Codable {
    var id: Int?
    var title: String
    var shortinformation: String?
    var detailinformation: String?
    var synonyms: String?
    var created: Date?
    var updated: Date?
    var userId: Int?
    var parent: Int?
    
    /*init(id: Int? = nil,
         title: String,
         shortinformation: String?,
         detailinformation: String?,
         synonyms: String?,
         userId: Int?,
         parent: Int?
        ) {
        self.id = id
        self.title = title
        self.shortinformation = shortinformation
        self.detailinformation = detailinformation
        self.synonyms = synonyms
        self.created = Date()
        self.updated = Date()
        self.userId = 1
        self.parent = parent
    }*/
}

extension JsonGeoinformation {
    static func get(id: Int32) -> Resource<JsonGeoinformation> {
        return Resource<JsonGeoinformation>(url: "geoinformations/" + String(id))
    }
}
