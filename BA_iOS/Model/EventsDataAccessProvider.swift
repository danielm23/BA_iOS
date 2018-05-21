import Foundation
import RxSwift
import CoreData


class EventsDataAccessProvider {
    
    private var storedEvents = Variable<[PersistantEvent]>([])
    private var managedObjectContext : NSManagedObjectContext
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as!
        AppDelegate).persistentContainer.viewContext
    
    init(){
        let delegate = UIApplication.shared.delegate as! AppDelegate
        storedEvents.value = [PersistantEvent]()
        managedObjectContext = delegate.persistentContainer.viewContext
        
        storedEvents.value = fetchData()
    }
    
    private func fetchData() -> [PersistantEvent] {
        let persistantEventFetchRequest = PersistantEvent.createFetchRequest()
        let sort = NSSortDescriptor(key: "name", ascending: true)
        persistantEventFetchRequest.sortDescriptors = [sort]
        do {
            return try managedObjectContext.fetch(persistantEventFetchRequest)
        }
        catch {
            return []
        }
    }
    
    // MARK: - return observable persistant event from Core Data
    public func fetchObservableData() -> Observable<[PersistantEvent]> {
        storedEvents.value = fetchData()
        return storedEvents.asObservable()
    }
    
    func storeNewEvents(loadedEvents: [JsonEvent]) {
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        DispatchQueue.main.async { [unowned self] in
            for newEvent in loadedEvents {
                let entity = NSEntityDescription.entity(forEntityName: "PersistantEvent", in: self.context)
                let persistantEvent = PersistantEvent(entity: entity!, insertInto: self.context)
                persistantEvent.configure(event: newEvent)
            }
            self.appDelegate.saveContext()
            self.storedEvents.value = self.fetchData()
        }
    }
    
    func loadEventsOfSchedule(qrCode: String){
        let dispatchGroup = DispatchGroup()

        let session = URLSession.shared
        let baseUrl : String = "https://danielmueller.fwd.wf/api"
        let schedulesRoute : String = "/schedules"
        let eventsRoute: String = "/events/"
        
        let requestUrl: String = baseUrl + schedulesRoute + "/" + qrCode + eventsRoute
        
        var errorMessage = ""
        let defaultSession = URLSession(configuration: .default)
        
        var dataTask: URLSessionDataTask?
        
        dataTask?.cancel()
        
        guard let url = URL(string: requestUrl) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        dataTask = defaultSession.dataTask(with: url) { data, response, error in
            
            dispatchGroup.enter()
            defer {dataTask = nil}
            
            if let error = error {
                errorMessage += "DataTask error: " + error.localizedDescription + "\n"
            } else if let data = data,
                let response = response as? HTTPURLResponse, response.statusCode == 200 {
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let newEvents = try decoder.decode([JsonEvent].self, from: data)
                    self.storeNewEvents(loadedEvents: newEvents)
                }
                catch let jsonErr {
                    print("Error json: ", jsonErr)
                }
            }
            dispatchGroup.leave()
        }
        dataTask?.resume()
    }
}

