import Foundation
import RxSwift
import CoreData

class EventDetailViewModel {
    var event = PersistantEvent()
    var eventDetailModel = EventDetailModel()
    var buttonText = PublishSubject<String>()
    public var isFavorite: Bool = true
    
    private var disposeBag = DisposeBag()
    
    public func getButtonText() -> String {
        if isFavorite {
            return "Delete as favorite" }
        else {
            return "Add to favorites" }
    }
    
    public func addEvents(newFavorite: PersistantEvent, orderNumber: Int) {
        eventDetailModel.storeNewEvents(newFavorite: newFavorite, orderNumber: orderNumber)
        isFavorite = true
    }
    
    public func removeFavorite() {
        eventDetailModel.removeFavorite(event: event)
        isFavorite = false
    }
    
    public func eventIsFavorite() -> Bool {
        return eventDetailModel.eventIsFavorite(event: event)
    }
    
    public func updateEvents() {
        eventDetailModel.reloadEvents()
    }
    
    func configureButton() {
        if isFavorite {
            removeFavorite()
        } else {
            addEvents(newFavorite: (event), orderNumber: 1)
        }
    }
}
