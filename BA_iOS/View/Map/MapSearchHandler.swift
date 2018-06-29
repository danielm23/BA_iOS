import Foundation
import MapKit

protocol LocationDisplayHandler {
    weak var mapView: MKMapView? { get }
    var selectedPin: MKPlacemark? { get set }
    var selectedLocation: JsonGeoSearchResult? { get set}
    
}

extension LocationDisplayHandler {
    mutating func dropPinZoomIn(location: JsonGeoSearchResult) {
        
        let position = CLLocationCoordinate2D(latitude: location.latitude!,
                                              longitude: location.longitude!)
        let placemark = MKPlacemark(coordinate: position)
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView?.removeAnnotations((mapView?.annotations)!)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        selectedLocation = location
        annotation.title = selectedLocation?.title
        
        mapView?.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.004, 0.004)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView?.setRegion(region, animated: true)
    }
}
