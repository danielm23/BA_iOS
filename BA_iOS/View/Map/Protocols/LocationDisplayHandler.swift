import Foundation
import MapKit

protocol LocationDisplayHandler: class {
    var mapView: MKMapView? { get }
    var selectedPin: MKPlacemark? { get set }
    var selectedLocation: JsonGeoOverview? { get set}
    
    func removeLocationInformations()
    func setInformation(forLocation location: JsonGeoOverview)
    func showOnMap(location: JsonGeoOverview)
    func clearRoute()
    func removeLocation()
}

extension LocationDisplayHandler {
    func showOnMap(location: JsonGeoOverview) {
        print("show on map entered")
        let position = CLLocationCoordinate2D(latitude: location.latitude!,
                                              longitude: location.longitude!)
        let placemark = MKPlacemark(coordinate: position)

        selectedPin = placemark

        mapView?.removeAnnotations((mapView?.annotations)!)
        mapView?.removeOverlays((mapView?.overlays)!)
        let annotation = MKPointAnnotation()
        print(placemark.coordinate)
        annotation.coordinate = placemark.coordinate
        
        annotation.title = selectedLocation?.title
        
        mapView?.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.004, 0.004)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView?.setRegion(region, animated: true)
        setInformation(forLocation: location)
    }
    
    func clearRoute(){
        mapView?.removeOverlays((mapView?.overlays)!)
    }
    
    func removeLocation() {
        let center = CLLocationCoordinate2D(latitude: 49.991537, longitude: 8.237983)
        mapView?.removeAnnotations(mapView!.annotations)
        mapView?.removeOverlays((mapView?.overlays)!)
        mapView?.setCenter(center, animated: true)
        mapView?.setRegion(MKCoordinateRegionMakeWithDistance(center, 1200, 1200), animated: true)
        
        removeLocationInformations()
    }
}
