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
    @IBOutlet weak var mapView: MKMapView?
    
    var rightItem = UIBarButtonItem()
    let favoriteButton: UIButton = UIButton(type: .custom)
    var selectedLocation: JsonGeoOverview?
    var selectedPin: MKPlacemark?
    
    /*enum SegueIdentifier: String {
        case showMap = "showMap"
    }*/

    @IBAction func NavigationButtonPressed(_ sender: UIButton) {
        print(selectedLocation)
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
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managedObjectContext = (self.tabBarController as! TabBarController).managedObjectContext

        configureButton()
        configureLabels()
        mapView?.mapType = .hybrid
        loadGeoInfos()
        
        print("categories: ")
        for category in event.categories! {
            print(category.title)
            print(category.isActive)
        }
        
        print("has active categories: ")
        print(event.hasActiveCategories)
        print(" ")
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
    
    fileprivate func updateMapView() {
        guard let map = mapView else { return }
        mapView?.mapType = .hybrid
    }
    
    func loadGeoInfos() {
        var config = LoadAndStoreConfiguration()
        config.mainContext = managedObjectContext
        let geoId = event.venue?.geoinformationId
        
        config.group.enter()
        Webservice().load(resource: JsonGeoOverview.get(of: geoId!), session: config.session) {
            overview in
                self.selectedLocation = overview
                config.group.leave()
        }
        config.group.notify(queue: .main) {
            self.showOnMap(location: self.selectedLocation!)
        }
    }
    
    func switchToMap() {
        let dispatchGrpup = DispatchGroup()
        
        dispatchGrpup.enter()
        guard let controller = self.tabBarController else { return }
        let navInstance = controller.childViewControllers[2] as! UINavigationController
        var dest = navInstance.childViewControllers[0] as! MapController
        controller.selectedIndex = 2
        dest.selectedLocation = selectedLocation
        dispatchGrpup.leave()
        dispatchGrpup.notify(queue: .main) {
            dest.showOnMap(location: dest.selectedLocation!)
        }
    }
}

extension EventDetailController: LocationDisplayHandler {
    
    func removeLocationInformations() {
        
    }
    
    func setInformation(forLocation location: JsonGeoOverview) {
        
    }
}
