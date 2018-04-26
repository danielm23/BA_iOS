import Foundation
import UIKit
import Mapbox

// DOKU
// https://www.mapbox.com/ios-sdk/api/3.7.6/

class MapController: UIViewController, MGLMapViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Set the map’s center coordinate and zoom level.
        mapView.setCenter(CLLocationCoordinate2D(latitude: 49.99, longitude: 8.23), zoomLevel: 14, animated: false)
        view.addSubview(mapView)
    }
}
