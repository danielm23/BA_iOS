import UIKit
import CoreData
import Foundation

class SchedulesCollectionController: UICollectionViewController, SegueHandler {
    
    var managedObjectContext: NSManagedObjectContext!
    fileprivate var dataSource: CollectionViewDataSource<SchedulesCollectionController>!
    fileprivate var observer: ManagedObjectObserver?
    
    enum SegueIdentifier: String {
        case showScheduleDetail = "showScheduleDetail"
        case showScanner = "showScanner"
    }
    
    /*
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
     */
    /*
    @IBAction func unwind(_ seque: UIStoryboardSegue) {
        if let sourceVC = seque.source as? ScannerController {
            if let id = sourceVC.qrCode {
                print(id)
                //loadEntities(ofScheudle: id)
            }
        }
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(UINib(nibName: "ScheduleCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "ScheduleCollectionCell")

        if managedObjectContext == nil {
            managedObjectContext = (self.tabBarController as! TabBarController).managedObjectContext
        }
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.topItem?.title = "Schedules"
        setupCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.dataSource.collectionView.reloadData()
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupCollectionView() {
        let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: (collectionView?.bounds.width)!, height: BaseRoundedCardCell.cellHeight)
        let request = Schedule.sortedFetchRequest
        request.fetchBatchSize = 20
        request.returnsObjectsAsFaults = false
        //let schedules = try! managedObjectContext.fetch(request)
        
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        dataSource = CollectionViewDataSource(collectionView: collectionView!, cellIdentifier: "ScheduleCollectionCell", fetchedResultsController: frc, delegate: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segueIdentifier(for: segue) {
        case .showScheduleDetail:
            guard let vc = segue.destination as? ScheduleDetailController else { fatalError("Wrong view controller type") }
            guard let schedule = dataSource.selectedObject else { fatalError("Showing detail, but no selected row") }
            vc.schedule = schedule
            vc.managedObjectContext = managedObjectContext
        case .showScanner:
            guard let scanner = segue.destination as? ScannerController else { fatalError("Wrong view controller") }
            scanner.managedObjectContext = managedObjectContext
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            performSegue(withIdentifier: "showScheduleDetail", sender: self)
        }
    }
}

extension SchedulesCollectionController: CollectionViewDataSourceDelegate {
    func configure(_ cell: ScheduleCollectionViewCell, for object: Schedule) {
        cell.configure(for: object)
    }
}
