import Foundation
import RxSwift
import CoreData

class EventDetailModel {
    
    private var favoriteEvents = Variable<[Favorites]>([])
    private var managedObjectContext : NSManagedObjectContext
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as!
        AppDelegate).persistentContainer.viewContext
    
    init(){
        let delegate = UIApplication.shared.delegate as! AppDelegate
        favoriteEvents.value = [Favorites]()
        managedObjectContext = delegate.persistentContainer.viewContext
        reloadEvents()
    }
    
    private func fetchData() -> [Favorites] {
        let favoritesFetchRequest = Favorites.createFetchRequest()
        let sort = NSSortDescriptor(key: "created", ascending: true)
        favoritesFetchRequest.sortDescriptors = [sort]
        do {
            return try managedObjectContext.fetch(favoritesFetchRequest)
        }
        catch {
            return []
        }
    }
    public func fetchObservableData() -> Observable<[Favorites]> {
        reloadEvents()
        return favoriteEvents.asObservable()
    }
    
    func eventIsFavorite(event: PersistantEvent) -> Bool{
        var isFavorite = false
        for favorite in favoriteEvents.value {
            if favorite.event.id == event.id {
                isFavorite = true
                break
            }
        }
        return isFavorite
    }
    
    func storeNewEvents(newFavorite: PersistantEvent, orderNumber: Int) {
        if !eventIsFavorite(event: newFavorite) {
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            DispatchQueue.main.async { [unowned self] in
                let entity = NSEntityDescription.entity(forEntityName: "Favorites", in: self.context)
                let favorite = Favorites(entity: entity!, insertInto: self.context)
                favorite.configure(event: newFavorite, number: orderNumber)
            }
            self.appDelegate.saveContext()
        }
        else {
            print("entry is already favorite")
        }
    }
    
    func getFavoriteFromPersistantEvent(event: PersistantEvent) -> Favorites {
        for favorite in favoriteEvents.value {
            if event.id == favorite.event.id {
                return favorite
            }
        }
        return Favorites()
    }
    
    public func removeFavorite(event: PersistantEvent) {
        managedObjectContext.delete(getFavoriteFromPersistantEvent(event: event))
        do {
            try managedObjectContext.save()
            reloadEvents()
        } catch {
            fatalError("error delete data")
        }
    }
    
    func reloadEvents() {
        favoriteEvents.value = fetchData()
    }
}
