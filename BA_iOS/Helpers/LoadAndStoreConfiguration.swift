import Foundation
import CoreData

struct LoadAndStoreConfiguration {
    var mainContext: NSManagedObjectContext?
    var syncContext: NSManagedObjectContext?
    let group = DispatchGroup()
    let session = URLSession.shared
    
    mutating func set(mainContext: NSManagedObjectContext) {
        self.mainContext = mainContext
    }
    
    mutating func set(syncContext: NSManagedObjectContext) {
        self.syncContext = syncContext
    }
}
