import Foundation
import CoreData

@objc(Category)
public class Category: NSManagedObject {
    
    @NSManaged fileprivate(set) var id: Int32
    @NSManaged fileprivate(set) var title: String
    @NSManaged fileprivate(set) var color: Int64
    @NSManaged var isActive: Bool
    
    @NSManaged public fileprivate(set) var schedule: Schedule?
    @NSManaged fileprivate(set) var events: Set<Event>?
}

extension Category: Managed {
    
    static var entityName: String {
        return "Category"
    }
    
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(title), ascending: true)]
    }
    
    static func insert(into context: NSManagedObjectContext, json: JsonCategory) -> Category {
        let category: Category = context.insertObject()
        
        category.id = Int32(json.id)
        category.title = json.name
        category.isActive = true
        
        let schedulePredicate = NSPredicate(format: "%K == %@", #keyPath(id), json.scheduleId)
        category.schedule = Schedule.findOrFetch(in: context, matching: schedulePredicate)
        
        return category
    }
    
    static func loadAndStore(identifiedBy scheduleId: String, config: LoadAndStoreConfiguration) {
        config.group.enter()
        Webservice().load(resource: JsonSchedule.getCategories(of: scheduleId), session: config.session) { categories in for category in categories! {
                print(category)
            config.mainContext?.performChanges {
                let _ = Category.insert(into: config.mainContext!, json: category)
                }
            }
            config.group.leave()
        }
    }
}

extension Category: Switchable { }
