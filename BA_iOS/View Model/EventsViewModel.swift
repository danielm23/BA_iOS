import Foundation
import RxSwift
import CoreData
   
struct EventsViewModel {
    
    public var events = Variable<[PersistantEvent]>([])
    private var eventsDataAccessProvider = EventsDataAccessProvider()
    private var disposeBag = DisposeBag()
    public var itemSelected = PersistantEvent()
    public var selectedItem = PublishSubject<IndexPath>()
    
    init() { 
        fetchEventsAndUpdateObservableEvents()
    }

    public func getEvents() -> Variable<[PersistantEvent]> {
        return events
    }
    
    public func getEvent(index: Int) -> PersistantEvent {
        return events.value[index]
    }
    
    private func fetchEventsAndUpdateObservableEvents() {
        eventsDataAccessProvider.fetchObservableData()
            .map({ $0 })
            .subscribe(onNext : { (events) in
                self.events.value = events
            })
            .disposed(by: disposeBag)
    }
    
    public func addEvents(withQrCode code: String) {
        eventsDataAccessProvider.loadEventsOfSchedule(qrCode: code)
    }
}
