import Foundation
import RxSwift
import CoreData

class EventDetailViewModel {
    var event = PersistantEvent()
    var eventDetailModel = EventDetailModel()
    
    private var disposeBag = DisposeBag()
    
    public func getButtonText() -> String {
        if eventIsFavorite() {
            return "Delete as favorite"
        }
        else {
            return "Add to favorites"
        }
    }
    
    public func addEvents(newFavorite: PersistantEvent, orderNumber: Int) {
        eventDetailModel.storeNewEvents(newFavorite: newFavorite, orderNumber: orderNumber)
    }
    
    public func eventIsFavorite() -> Bool {
        return eventDetailModel.eventIsFavorite(event: event)
    }

}
