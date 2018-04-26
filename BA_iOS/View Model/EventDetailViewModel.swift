import Foundation
import RxSwift
import CoreData

class EventDetailViewModel {
    // var venues
    // var persons
    
    //var event = PublishSubject<PersistantEvent>()
    var event = PersistantEvent()
    var favoritesViewModel = FavoritesViewModel()
    var eventDetailModel = EventDetailModel()
    //public var event = PublishSubject<IndexPath>()
    
    private var disposeBag = DisposeBag()
    
    /*public func getEvent() -> PublishSubject<PersistantEvent>{
        return event
    }
    
    public func getEvent() -> PersistantEvent {
        print(event)
        return event
    }*/
}
