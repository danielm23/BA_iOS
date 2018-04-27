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
}
