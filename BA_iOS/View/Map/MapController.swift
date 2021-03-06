import Foundation
import UIKit
import MapKit
import CoreData
import CoreLocation

class MapController: UIViewController {

    // https://stackoverflow.com/questions/37967555/how-can-i-mimic-the-bottom-sheet-from-the-maps-app/38152508#38152508
    
    // Outlets
    @IBOutlet var mapView: MKMapView?
    var mapDetailController: MapDetailController?

    // Responsibilities
    let locationManager = CLLocationManager()
    var searchController: UISearchController? = nil

    // Selected Location
    var selectedLocation: JsonGeoOverview?
    var selectedPin: MKPlacemark?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMapView()
        configureLocationManager()
        configureSearchController()
        removeLocation()
        loadMessages()
    }
    
    func loadMessages() {
        let tabBarController = self.tabBarController as! TabBarController
        tabBarController.loadAndCountMessages()
    }
}

extension MapController: CLLocationManagerDelegate {
    
    func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func locationManager(manager: CLLocationManager,
                                 didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
}

extension MapController: MKMapViewDelegate {
    
    func configureMapView() {
        mapView?.delegate = self
        mapView?.mapType = .hybrid
        mapDetailController = storyboard!.instantiateViewController(
            withIdentifier: "MapDetailController") as? MapDetailController
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.5
        return renderer
    }
}

extension MapController: UISearchControllerDelegate {
    
    func configureSearchController() {
        let locationSearchController = storyboard!
            .instantiateViewController(withIdentifier: "LocationSearchController")
            as! LocationSearchController
        locationSearchController.handleMapSearchDelegate = self
        
        searchController = UISearchController(searchResultsController: locationSearchController)
        searchController?.searchResultsUpdater = locationSearchController
        searchController?.delegate = self
        searchController?.obscuresBackgroundDuringPresentation = true
        searchController?.searchBar.delegate = locationSearchController
        searchController?.searchBar.placeholder = "Suche Orte"
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

extension MapController: LocationDisplayHandler {
    
    func removeLocationInformations() { }
    
    func setInformation(forLocation location: JsonGeoOverview) {
        addInformationOverlay()
        mapDetailController?.titleLabel.text = location.title
    }
}

extension MapController: NavigationHandler {
    func startNavigation() {
        let destination = CLLocation(latitude: (selectedLocation?.latitude)!,
                                     longitude: (selectedLocation?.longitude)!)
        showRoute(from: locationManager.location!, to: destination)
    }
}

extension MapController {
    func addInformationOverlay() {
        mapDetailController?.handleNavigationButtonDelegate = self
        self.addChildViewController(mapDetailController!)
        self.view.addSubview((mapDetailController?.view)!)
        mapDetailController?.didMove(toParentViewController: self)
        mapDetailController?.view.frame = CGRect(x: 0, y: self.view.frame.maxY,
                                      width: view.frame.width, height: view.frame.height)
    }
    
    func removeInformationOverlay() {
        let vc = self.childViewControllers.last
        vc?.view.removeFromSuperview()
        vc?.removeFromParentViewController()
    }
}
