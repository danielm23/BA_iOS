import Foundation
import MapKit
import UIKit

// "class" needed for reference with self
protocol NavigationHandler: class {
    weak var mapView: MKMapView? { get }
}

extension NavigationHandler {
    
    
    
    func showRoute(from start: CLLocation, to destination: CLLocation) {

        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: start.coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination.coordinate))
        request.requestsAlternateRoutes = false
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        
        directions.calculate {
            [weak self] (response, error) in
            if error == nil {
                let route = response!.routes.first
                self?.mapView?.add((route?.polyline)!)
                
                let edgeInsets = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
                
                self?.mapView?.setVisibleMapRect((route?.polyline.boundingMapRect)!,
                                                 edgePadding: edgeInsets,
                                                 animated: true)
            }
            else { print(error.debugDescription) }
        }
    }
}
