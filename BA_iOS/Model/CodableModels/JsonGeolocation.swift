import Foundation

final public class JsonGeolocation: Codable {
    var id: Int?
    var adress: String?
    var zip: String?
    var city: String?
    var country: String?
    var longitude: Double?
    var latitude: Double?
    var floor: Int?
    var created: Date?
    var updated: Date?
    var userId: Int?
    
    init(
        adress: String,
        zip: String,
        city: String,
        country: String,
        longitude: Double,
        latitude: Double,
        floor: Int,
        created: Date,
        updated: Date
        ) {
        self.adress = adress
        self.zip = zip
        self.city = city
        self.country = country
        self.longitude = longitude
        self.latitude = latitude
        self.floor = floor
        self.created = Date()
    }
}

extension JsonGeolocation {
    static func get(of geoinformation: Int32) -> Resource<[JsonGeolocation]> {
        return Resource<[JsonGeolocation]>(url: "geoinformations/" + String(geoinformation) + "/locations")
    }
}
