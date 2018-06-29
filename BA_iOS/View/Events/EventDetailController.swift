import Foundation
import UIKit
import CoreData
import MapKit

class EventDetailController: UIViewController /*, SegueHandler*/ {
    
    var managedObjectContext: NSManagedObjectContext!
    
    @IBOutlet weak var label: UILabel! //name
    @IBOutlet weak var venueLabel: UILabel!
    @IBOutlet weak var eventDetail: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var rightItem = UIBarButtonItem()
    let favoriteButton: UIButton = UIButton(type: .custom)
     var location: JsonGeoOverview?
    
    /*enum SegueIdentifier: String {
        case showMap = "showMap"
    }*/

    @IBAction func NavigationButtonPressed(_ sender: UIButton) {
        print(location)
        switchToMap()
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
        managedObjectContext = (self.tabBarController as! TabBarController).managedObjectContext

        configureButton()
        configureLabels()
        loadGeoInfos()
        
        
        for category in event.categories! {
            print(category.title)
        }
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
        
        favoriteButton.setImage(UIImage(named: "star")?.withRenderingMode(.alwaysTemplate), for: .normal)
        favoriteButton.setImage(UIImage(named: "filledStar")?.withRenderingMode(.alwaysTemplate), for: .selected)
        favoriteButton.addTarget(self, action: #selector(self.favoriteButtonPressed(_:)), for: .touchUpInside)
        favoriteButton.tintColor = view.tintColor
        rightItem = UIBarButtonItem(customView: favoriteButton)
        self.navigationItem.rightBarButtonItem = rightItem
        
        if event.isFavorite {
            favoriteButton.isSelected = true
        }
    }
    
    /*fileprivate func setAnnotation(forLocationOf event: Event) {
        guard let annotation = EventAnnotation(event: event) else { return }
        mapView.removeAnnotations(mapView!.annotations)
        mapView.addAnnotation(annotation)
        mapView.selectAnnotation(annotation, animated: true)
        mapView.setCenter(annotation.coordinate, animated: false)
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(annotation.coordinate, 350, 350), animated: false)
    }*/
    
    fileprivate func updateMapView() {
        guard let map = mapView else { return }
        mapView.mapType = .hybrid
        //if event.venue?.geoinformation != nil {
        //    //setAnnotation(forLocationOf: event)
        //}
    }
    
    func loadGeoInfos() {
        var config = LoadAndStoreConfiguration()
        config.context = managedObjectContext
        let geoId = event.venue?.geoinformationId
        
        config.group.enter()
        Webservice().load(resource: JsonGeoOverview.get(of: geoId!), session: config.session) {
            overview in
                self.location = overview
                config.group.leave()
        }
        config.group.notify(queue: .main) {
            print("location:")
            print(self.location?.title)
        }
        

        //GeoOverview.loadAndStore(identifiedBy: geoId!, config: config)
        
        //let locationPredicate = NSPredicate(format: "%K == %@", #keyPath(id), geoId!)
        //let loc = GeoOverview.findOrFetch(in: managedObjectContext, matching: locationPredicate)
        
        //let jsonEncoder = JSONEncoder()
        //let jsonData = try jsonEncoder.encode(loc)
        //location = jsonData
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segueIdentifier(for: segue) {
        case .showMap:
            //guard let event = event else { fatalError("Showing detail, but no selected row?")
            let mapVc = segue.destination as! MapController
            //mapVc.event = event
            mapVc.navigationButton.isSelected = true
        }
    }*/
    
    func switchToMap() {
        
        guard let controller = self.tabBarController else { return }
        let navInstance = controller.childViewControllers[2] as! UINavigationController
        var dest = navInstance.childViewControllers[0] as! MapController
        //dest.selectedLocation = location
        //print(dest.selectedLocation)
        //dest.showOnMap(location: location!)
        controller.selectedIndex = 2
        dest.selectedLocation = location
        print(dest.selectedLocation?.title)
        dest.showOnMap(location: dest.selectedLocation!)
        //self.present(controller, animated: true, completion: nil)
    }
}
