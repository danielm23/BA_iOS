import Foundation
import CoreData

struct LoadAndStoreConfiguration {
    var context: NSManagedObjectContext?// = nil
    let group = DispatchGroup()
    let session = URLSession.shared
    
    mutating func set(context: NSManagedObjectContext) {
        self.context = context
    }
}
