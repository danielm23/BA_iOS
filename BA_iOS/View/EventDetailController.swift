import Foundation
import UIKit
import RxSwift
import RxCocoa

class EventDetailController: UIViewController {
    
    var eventDetailViewModel = EventDetailViewModel()
    var disposeBag = DisposeBag()

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    @IBAction func button(_ sender: Any) {
        print("buttonpressed")
        eventDetailViewModel.favoritesViewModel.addEvents(newFavorite: eventDetailViewModel.event, orderNumber: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = eventDetailViewModel.event.name
        populateFavoritesTableView()
    }
    
    private func populateFavoritesTableView() {
        let observableEvents = eventDetailViewModel
            .favoritesViewModel
            .getEvents().asObservable()
 
            observableEvents.bind(to: favoritesTableView
                .rx
                .items(cellIdentifier: "FavoriteCell", cellType:  FavoritesTableViewCell.self)) { (row, element, cell) in
                    cell.configure(item: element)
                }
                .disposed(by: disposeBag)
    }
}
