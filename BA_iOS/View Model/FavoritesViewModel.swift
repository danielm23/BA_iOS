import Foundation
import RxSwift
import CoreData

class FavoritesViewModel {
    
    private var events = Variable<[Favorites]>([])
    private var disposeBag = DisposeBag()
    private var favoritesModel = FavoritesModel()
    
    var selectedEvent = PersistantEvent()
    var selectedEvetntInt: Int = 0
    
    init() {
        fetchEventsAndUpdateObservableEvents()
    }
    
    private func fetchEventsAndUpdateObservableEvents() {
        favoritesModel.fetchObservableData().map({ $0 })
            .subscribe(onNext : { (events) in
                self.events.value = events
            })
            .disposed(by: disposeBag)
    }
    
    public func getEvent(index: Int) -> PersistantEvent {
        return events.value[index].event
    }
    
    public func getEvents() -> Variable<[Favorites]> {
        return events
    }
    
    public func aff(newFavorite: PersistantEvent, orderNumber: Int) {
        favoritesModel.storeNewEvents(newFavorite: newFavorite, orderNumber: orderNumber)
    }
    
    public func updateEvents() {
        favoritesModel.reloadEvents()
    }
    
    public func removeFavorite(withIndex index: Int) {
        favoritesModel.removeFavorite(withIndex: index)
    }
}
