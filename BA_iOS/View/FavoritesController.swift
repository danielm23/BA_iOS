import Foundation
import UIKit
import RxSwift
import RxCocoa

class FavoritesController: UIViewController {
    
    var favoritesViewModel = FavoritesViewModel()
    var disposeBag = DisposeBag()
    
    
    @IBOutlet var favoritesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateFavoritesTableView()
        setupTodoListTableViewCellWhenDeleted()
        setupTodoListTableViewCellWhenItemAccessoryButtonTapped()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("willAppear")
        updateEvents()
    }
    
    private func updateEvents() {
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
    
    private func setupTodoListTableViewCellWhenDeleted() {
        favoritesTableView.rx.itemDeleted
            .subscribe(onNext : { indexPath in
                self.favoritesViewModel.removeFavorite(withIndex: indexPath.row)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupTodoListTableViewCellWhenItemAccessoryButtonTapped() {
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
        self.show(destViewController, sender: nil)
    }
}
