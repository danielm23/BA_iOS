import Foundation
final public class JsonGeoOverview: Codable {

    var id: Int // equals geoinformationId
    var title: String?
    var latitude: Double?
    var longitude: Double?
    
    init(
        id: Int,
        title: String,
        latitude: Double?,
        longitude: Double?
        ) {
        self.id = id
        self.title = title
        self.latitude = latitude
        self.longitude = longitude
    }
}

extension JsonGeoOverview {

    static func get(resultsFor searchTerm: String) -> Resource<[JsonGeoOverview]> {

        let geoSearch = [URLQueryItem(name: "searchTerm", value: searchTerm)]
        return Resource<[JsonGeoOverview]>(url: "geosearch", querys: geoSearch)
    }
    
    static func get(of id: Int32) -> Resource<JsonGeoOverview> {
        return Resource<JsonGeoOverview>(url: "geoinformations/overview/" + String(id))
    }
}
