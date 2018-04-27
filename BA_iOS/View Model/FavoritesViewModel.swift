import Foundation
import RxSwift
import CoreData

class FavoritesViewModel {
    
    private var events = Variable<[Favorites]>([])
    private var disposeBag = DisposeBag()
    private var favoritesModel = FavoritesModel()
    
    init() {
        fetchEventsAndUpdateObservableEvents()
    }
    
    public func getEvents() -> Variable<[Favorites]> {
        return events
    }
    
    private func fetchEventsAndUpdateObservableEvents() {
        favoritesModel.fetchObservableData().map({ $0 })
            .subscribe(onNext : { (events) in
                self.events.value = events
            })
            .disposed(by: disposeBag)
    }
    
    // change to switch status
    public func addEvents(newFavorite: PersistantEvent, orderNumber: Int) {
        favoritesModel.storeNewEvents(newFavorite: newFavorite, orderNumber: orderNumber)
        print("addEvents()")
        print(newFavorite)
    }
    
    public func updateEvents() {
        favoritesModel.reloadEvents()
    }
}
