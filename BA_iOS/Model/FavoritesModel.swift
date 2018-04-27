import Foundation
import RxSwift
import CoreData

class FavoritesModel {
    
    private var favoriteEvents = Variable<[Favorites]>([])
    private var managedObjectContext : NSManagedObjectContext
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as!
        AppDelegate).persistentContainer.viewContext
    
    init(){
        let delegate = UIApplication.shared.delegate as! AppDelegate
        favoriteEvents.value = [Favorites]()
        managedObjectContext = delegate.persistentContainer.viewContext
        favoriteEvents.value = fetchData()
    }
    
    private func fetchData() -> [Favorites] {
        let favoritesFetchRequest = Favorites.createFetchRequest()
        let sort = NSSortDescriptor(key: "created", ascending: true)
        favoritesFetchRequest.sortDescriptors = [sort]
        do {
            print("fetchData()")
            return try managedObjectContext.fetch(favoritesFetchRequest)
        }
        catch {
            return []
        }
    }
    public func fetchObservableData() -> Observable<[Favorites]> {
        favoriteEvents.value = fetchData()
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
        if eventIsFavorite(event: newFavorite) {
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
    
    public func reloadEvents() {
        favoriteEvents.value = fetchData()
    }
    /*
    func storeNewEvents(newFavorite: PersistantEvent, orderNumber: Int) {
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        DispatchQueue.main.async { [unowned self] in
            let entity = NSEntityDescription.entity(forEntityName: "Favorites", in: self.context)
            let favorite = Favorites(entity: entity!, insertInto: self.context)
            favorite.configure(event: newFavorite, number: orderNumber)
        }
        self.appDelegate.saveContext()
        //self.favoriteEvents.value = self.fetchData()
    }*/
}
