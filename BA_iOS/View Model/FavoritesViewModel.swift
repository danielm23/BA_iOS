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
    
    public func getEvent(index: Int) -> PersistantEvent {
        return events.value[index].event
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
    
    public func addEvents(newFavorite: PersistantEvent, orderNumber: Int) {
        favoritesModel.storeNewEvents(newFavorite: newFavorite, orderNumber: orderNumber)
        print("addEvents()")
        print(newFavorite)
    }
    
    public func updateEvents() {
        favoritesModel.reloadEvents()
    }
    
    public func removeFavorite(withIndex index: Int) {
        favoritesModel.removeFavorite(withIndex: index)
    }
}
