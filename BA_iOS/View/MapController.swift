import Foundation
import UIKit
import MapboxDirections
import MapboxGeocoder
import Mapbox
import MapKit


class MapController: UIViewController, MGLMapViewDelegate {
    var current = CLLocationCoordinate2D()
    var destination = MGLPointAnnotation()
    //var mapView = MGLMapView()
    
    /*
    let candies = [
    Candy(category:"Chocolate", name:"Chocolate Bar"),
    Candy(category:"Chocolate", name:"Chocolate Chip"),
    Candy(category:"Chocolate", name:"Dark Chocolate"),
    Candy(category:"Hard", name:"Lollipop"),
    Candy(category:"Hard", name:"Candy Cane"),
    Candy(category:"Hard", name:"Jaw Breaker"),
    Candy(category:"Other", name:"Caramel"),
    Candy(category:"Other", name:"Sour Chew"),
    Candy(category:"Other", name:"Gummi Bear"),
    Candy(category:"Other", name:"Candy Floss"),
    Candy(category:"Chocolate", name:"Chocolate Coin"),
    Candy(category:"Chocolate", name:"Chocolate Egg"),
    Candy(category:"Other", name:"Jelly Beans"),
    Candy(category:"Other", name:"Liquorice"),
    Candy(category:"Hard", name:"Toffee Apple")
    ]*/
    
    
    
    var resultSearchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var mapView: MGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //mapView = MGLMapView(frame: view.bounds)
        mapView.delegate = self
        
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: false)

        view.addSubview(mapView)

        configureDestination(latitude: 49.9, longitude: 8.23)
        
        mapView.addAnnotation(destination)
        
        resultSearchController.searchResultsUpdater = self
        resultSearchController.obscuresBackgroundDuringPresentation = false
        resultSearchController.searchBar.placeholder = "Search"
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchController") as! LocationSearchController
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController.searchResultsUpdater = locationSearchTable
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = true
        
        navigationItem.title = "Locations"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = resultSearchController
        navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
    }
    
    func configureDestination(latitude: Double, longitude: Double) {
        destination.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        destination.title = "Destination"
        destination.subtitle = "your destination"
    }
        
    func displayRoute () {
        
        let directions = Directions.shared

        let waypoints = [
            Waypoint(coordinate: destination.coordinate, name: "Start"),
            Waypoint(coordinate: current, name: "Ziel"),
            ]
        
        let options = RouteOptions(waypoints: waypoints, profileIdentifier: .walking)
        options.includesSteps = false
        
        let task = directions.calculate(options) { (waypoints, routes, error) in
            guard error == nil else {
                print("Error calculating directions: \(error!)")
                return
            }
            
            if let route = routes?.first, let leg = route.legs.first {
                print("Route via \(leg):")
                
                let distanceFormatter = LengthFormatter()
                let formattedDistance = distanceFormatter.string(fromMeters: route.distance)
                
                let travelTimeFormatter = DateComponentsFormatter()
                travelTimeFormatter.unitsStyle = .short
                let formattedTravelTime = travelTimeFormatter.string(from: route.expectedTravelTime)
                
                print("Distance: \(formattedDistance); ETA: \(formattedTravelTime!)")
                
                if route.coordinateCount > 0 {
                    // Convert the route’s coordinates into a polyline.
                    var routeCoordinates = route.coordinates!
                    let routeLine = MGLPolyline(coordinates: &routeCoordinates, count: route.coordinateCount)
                    
                    // Add the polyline to the map and fit the viewport to the polyline.
                    self.mapView.addAnnotation(routeLine)
                    self.mapView.setVisibleCoordinates(&routeCoordinates, count: route.coordinateCount, edgePadding: .zero, animated: true)
                }
            }
        }
    }
    
    func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
        print("updated location")
        current = (mapView.userLocation?.coordinate)!
        print(current)
        displayRoute()
    }

    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
}

extension MapController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
    }
}
