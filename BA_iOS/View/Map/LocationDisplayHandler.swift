import Foundation
import MapKit

protocol LocationDisplayHandler: class {
    weak var mapView: MKMapView? { get }
    var selectedPin: MKPlacemark? { get set }
    var selectedLocation: JsonGeoOverview? { get set}
    
    //func setInformations()
    func removeLocationInformations()
    func setInformation(for location: JsonGeoOverview)
}

extension LocationDisplayHandler {
    func showOnMap(location: JsonGeoOverview) {
        print("showOnMap")
        let position = CLLocationCoordinate2D(latitude: location.latitude!,
                                              longitude: location.longitude!)
        let placemark = MKPlacemark(coordinate: position)
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView?.removeAnnotations((mapView?.annotations)!)
        mapView?.removeOverlays((mapView?.overlays)!)
        let annotation = MKPointAnnotation()
        print(placemark.coordinate)
        annotation.coordinate = placemark.coordinate
        
        //selectedLocation = location
        annotation.title = selectedLocation?.title
        
        mapView?.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.004, 0.004)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView?.setRegion(region, animated: true)
        
        //setInformation(for: location)
    }
    
    func clearMap(){
        let center = CLLocationCoordinate2D(latitude: 49.991537, longitude: 8.237983)
        mapView?.removeAnnotations(mapView!.annotations)
        mapView?.removeOverlays((mapView?.overlays)!)
        mapView?.setCenter(center, animated: true)
        mapView?.setRegion(MKCoordinateRegionMakeWithDistance(center, 1200, 1200), animated: true)

        removeLocationInformations()
    }
}
