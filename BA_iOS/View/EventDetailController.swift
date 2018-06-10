import Foundation
import UIKit
import CoreData
import MapKit

class EventDetailController: UIViewController, SegueHandler {
    
    var managedObjectContext: NSManagedObjectContext!
    
    @IBOutlet weak var label: UILabel! //name
    @IBOutlet weak var venueLabel: UILabel!
    @IBOutlet weak var eventDetail: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var rightItem = UIBarButtonItem()
    let favoriteButton: UIButton = UIButton(type: .custom)
    
    enum SegueIdentifier: String {
        case showMap = "showMap"
    }

    @IBAction func NavigationButtonPressed(_ sender: UIButton) {
        print("nav")
    }
    
    fileprivate var observer: ManagedObjectObserver?
    
    @objc var event: Event! {
        didSet {
            observer = ManagedObjectObserver(object: event) { [unowned self] type in
                guard type == .update else { return }
                //let _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        favoriteButton.isSelected = !favoriteButton.isSelected
        self.managedObjectContext.performChanges {
            let _ = self.event.switchFavoriteStatus()
            print("switched status")
            print(self.event.isFavorite)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButton()
        configureLabels()
        loadGeoInfos()
    }
    
    fileprivate func configureLabels() {
        navigationItem.title = event.schedule?.name
        label.text = event.name
        venueLabel.text = event.venue?.name
        eventDetail.text = event.info
        
        let timeFormatter = DateFormatter()
        let dateFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        dateFormatter.dateFormat = "dd.MM.yyyy"
        timeLabel.text = dateFormatter.string(from: event.startDate!) + "\n" + timeFormatter.string(from: event.startDate!) + " bis " + timeFormatter.string(from: event.endDate!) + "Uhr"
    }
    
    fileprivate func configureButton() {
        favoriteButton.setImage(UIImage(named: "NoFavorite"), for: .normal)
        favoriteButton.setImage(UIImage(named: "Favorite"), for: .selected)
        favoriteButton.addTarget(self, action: #selector(self.favoriteButtonPressed(_:)), for: .touchUpInside)
        rightItem = UIBarButtonItem(customView: favoriteButton)
        self.navigationItem.rightBarButtonItem = rightItem
        
        if event.isFavorite {
            favoriteButton.isSelected = true
        }
    }
    
    fileprivate func updateMapView() {
        //coordinate.latitude = 50
        //coordinate.longitude = 8.23
        
        guard let map = mapView, let annotation = EventAnnotation(event: event) else { return }
        map.removeAnnotations(mapView!.annotations)
        map.addAnnotation(annotation)
        map.mapType = .hybrid
        //map.selectAnnotation(annotation, animated: true)
        map.setCenter(annotation.coordinate, animated: false)
        map.setRegion(MKCoordinateRegionMakeWithDistance(annotation.coordinate, 300, 300), animated: false)
    }
    
    func loadGeoInfos() {
        let config = LoadAndStoreConfiguration(context: managedObjectContext)
        config.group.enter()
        Webservice().load(resource: JsonGeoinformation.get(id: (event.venue?.geoinformationId)!), session: config.session) { geoinformation in
            self.event.venue?.setGeoinformation(info: geoinformation!)
            config.group.leave()
        }
        config.group.enter()
        Webservice().load(resource: JsonGeolocation.get(of: (event.venue?.geoinformationId)!), session: config.session) { geolocations in
            for geolocation in geolocations! {
                self.event.venue?.setGeolocation(location: geolocation)
                config.group.leave()
            }
            config.group.notify(queue: .main) {
                self.updateMapView()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segueIdentifier(for: segue) {
        case .showMap:
            //guard let event = event else { fatalError("Showing detail, but no selected row?")
            let mapVc = segue.destination as! MapController
            mapVc.event = event
        }
    }
}
