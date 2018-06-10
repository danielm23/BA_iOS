import Foundation
import UIKit

class FavoritesController: UIViewController {
    
    @IBOutlet var favoritesTableView: UITableView!
    /*
    var favoritesViewModel = FavoritesViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateFavoritesTableView()
        setupFavoritesTableViewCellWhenDeleted()
        setupFavoritesTableViewCellWhenItemAccessoryButtonTapped()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoritesViewModel.updateEvents()
    }
    
    private func populateFavoritesTableView() {
        let observableEvents = favoritesViewModel
            .getEvents()
            .asObservable()
        
        observableEvents.bind(to: favoritesTableView
            .rx
            .items(cellIdentifier: "FavoriteCell", cellType:  FavoritesTableViewCell.self)) { (row, element, cell) in
                cell.configure(item: element)
            }
        .disposed(by: disposeBag)
    }
    
    private func setupFavoritesTableViewCellWhenDeleted() {
        favoritesTableView.rx.itemDeleted
            .subscribe(onNext : { indexPath in
                self.favoritesViewModel.removeFavorite(withIndex: indexPath.row)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupFavoritesTableViewCellWhenItemAccessoryButtonTapped() {
        favoritesTableView.rx.itemAccessoryButtonTapped
            .subscribe(onNext : { indexPath in
                self.favoritesViewModel.selectedEvent = self.favoritesViewModel.getEvent(index: indexPath.row)
                self.switchVC()
            })
            .disposed(by: disposeBag)
    }
    
    func switchVC() {
        let destViewController = storyboard?.instantiateViewController(withIdentifier: "EventDetailController") as! EventDetailController
        destViewController.eventDetailViewModel.event = favoritesViewModel.selectedEvent
        destViewController.eventDetailViewModel.isFavorite = destViewController.eventDetailViewModel.eventIsFavorite()
        print(destViewController.eventDetailViewModel.isFavorite)
        self.show(destViewController, sender: nil)
    }*/ 
}
