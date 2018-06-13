import Foundation
import UIKit
import MapKit
import CoreData

class MapController: UIViewController  {
    
    fileprivate var observer: ManagedObjectObserver?
    
    var event: Event?
    var locationManager: CLLocationManager?
    var startLocation: CLLocation?
    //var location: CLLocation!
    var resultSearchController = UISearchController(searchResultsController: nil)
    
    
    var managedObjectContext: NSManagedObjectContext!

    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func navigationButton(_ sender: Any) {
        print(locationManager?.location)
        if (event != nil) {
            startNavigation()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.managedObjectContext = (self.tabBarController as! TabBarController).managedObjectContext
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        
        mapView.delegate = self
        mapView.mapType = .hybrid
        
        if (event != nil) {
            setAnnotation(forLocationOf: event!)
        }
    }
    
    fileprivate func setAnnotation(forLocationOf event: Event) {
        guard let annotation = EventAnnotation(event: event) else { return }
        mapView.removeAnnotations(mapView!.annotations)
        mapView.addAnnotation(annotation)
        mapView.selectAnnotation(annotation, animated: true)
        mapView.setCenter(annotation.coordinate, animated: false)
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(annotation.coordinate, 800, 800), animated: false)
    }
    
    
    
    func startNavigation() {
        
        let sourcePlacemark = MKPlacemark(coordinate: (locationManager?.location?.coordinate)!, addressDictionary: nil)
        
        let destinationLocation = CLLocation(latitude: (event?.venue?.geolocation?.latitude)!, longitude: (event?.venue?.geolocation?.longitude)!)

        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation.coordinate, addressDictionary: nil)
        
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: sourcePlacemark)
        request.destination = MKMapItem(placemark: destinationPlacemark)
        request.requestsAlternateRoutes = false
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        
        directions.calculate {
            [weak self] (response, error) in
            if error == nil {
                let route = response!.routes.first
                self?.mapView.add((route?.polyline)!)
                for step in (route?.steps)! {
                    print(step.instructions)
                }
            }
        }
    }
}

extension MapController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if startLocation == nil {
            startLocation = locations.first
        } else {
            guard let latest = locations.first else { return }
            let distanceInMeters = startLocation?.distance(from: latest)
            print("distance in meters: \(distanceInMeters)")
        }
    }
    
    fileprivate func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager?.startUpdatingLocation()
        }
    }
}

extension MapController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.5
        return renderer
    }
}
/*
extension MapController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
    }
}
*/
public class EventAnnotation: NSObject, MKAnnotation {
    public var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    public let title: String?
    
    init?(event: Event) {
        self.coordinate.longitude = (event.venue?.geolocation?.longitude)!
        self.coordinate.latitude = (event.venue?.geolocation?.latitude)!
        title = event.venue?.geoinformation?.title
        super.init()
    }
}
