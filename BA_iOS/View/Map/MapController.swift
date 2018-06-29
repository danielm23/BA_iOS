import Foundation
import UIKit
import MapKit
import CoreData
import CoreLocation

class MapController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView?
    @IBOutlet weak var selectedLocationView: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var navigationButton: UIButton!
    
    var selectedLocation: JsonGeoOverview?
    var selectedPin: MKPlacemark?
    //var currentLocation: CLLocation?
    
    let locationManager = CLLocationManager()
    
    var searchController: UISearchController? = nil
    
    @IBAction func navigationButton(_ sender: Any) {
        print(navigationButton.state) // 1: clear, 5: navigation

        switch navigationButton.state.rawValue {
        case 1:
            print("case 1")
            clearMap()
        default:
            let destination = CLLocation(latitude: (selectedLocation?.latitude)!,
                                         longitude: (selectedLocation?.longitude)!)
            showRoute(from: locationManager.location!, to: destination)
            navigationButton.isSelected = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationManager()
        configureSearchController()
        configuresSelectedLocationButton()
        configureMapView()
        //clearMap()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if selectedLocation != nil {
            print("is selected -> nevigation")
            navigationButton.isSelected = true
        }
        else {
            print("not selected -> clear")
            navigationButton.isSelected = false
            clearMap()
        }
    }
    
    func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func configureSearchController() {
        let locationSearchController = storyboard!.instantiateViewController(withIdentifier: "LocationSearchController") as! LocationSearchController
        locationSearchController.handleMapSearchDelegate = self
        
        searchController = UISearchController(searchResultsController: locationSearchController)
        searchController?.searchResultsUpdater = locationSearchController
        searchController?.delegate = self
        searchController?.obscuresBackgroundDuringPresentation = true
        searchController?.searchBar.delegate = locationSearchController
        searchController?.searchBar.placeholder = "Search Locations"
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func configuresSelectedLocationButton() {
        
        navigationButton.setTitle("Clear", for: .normal)
        navigationButton.setTitle("Navigation", for: .selected)
    }
    
    
    func setLocationInformations() {
        locationLabel.text = selectedLocation?.title
        navigationButton.isSelected = true
    }
    
    func removeLocationInformations() {
        locationLabel.text = ""
    }
    
    func configureMapView() {
        mapView?.delegate = self
        mapView?.mapType = .hybrid
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController?.searchBar.text?.isEmpty ?? true
    }
    
    

}
/*
extension MapController {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didupdateloc")
        if currentLocation == nil {
            currentLocation = locations.first
            print(locations.first)
        }
        else {
            guard let latest = locations.first else { return }
        }
        
        print(currentLocation)
    }
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("didchangeauth")
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            print("startUpdating")
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("Location manager failed with error = \(error)")
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        print("locationManagerDidPauseLocationUpdates")
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        print("locationManagerDidResumeLocationUpdates")
    }
}*/

extension MapController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.5
        print("renderer applied")
        return renderer
    }
}

extension MapController: SegueHandler {
    enum SegueIdentifier: String {
        case searchTest = "searchTest"
    }
}

extension MapController: UISearchControllerDelegate { }

extension MapController: LocationDisplayHandler {    
    func setInformation(for location: JsonGeoOverview) {
        locationLabel.text = location.title
        navigationButton.isSelected = true
    }
}

extension MapController: NavigationHandler { }

