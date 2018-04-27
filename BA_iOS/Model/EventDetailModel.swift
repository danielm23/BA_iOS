import Foundation
import RxSwift
import CoreData

class EventDetailModel {
    
    private var managedObjectContext : NSManagedObjectContext
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as!
        AppDelegate).persistentContainer.viewContext
    
    init(){
        let delegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = delegate.persistentContainer.viewContext
    }
    
    func storeNewEvents(newFavorite: PersistantEvent, orderNumber: Int) {
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        DispatchQueue.main.async { [unowned self] in
            let entity = NSEntityDescription.entity(forEntityName: "Favorites", in: self.context)
            let favorite = Favorites(entity: entity!, insertInto: self.context)
            favorite.configure(event: newFavorite, number: orderNumber)
        }
        self.appDelegate.saveContext()
    }
}
