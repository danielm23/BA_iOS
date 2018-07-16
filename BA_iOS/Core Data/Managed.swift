import CoreData

 protocol Managed: NSFetchRequestResult {
    static var entityName: String { get }
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
    
    associatedtype Input: Decodable
    associatedtype Output: Managed
    associatedtype Identifier
    
    static func insert(into context: NSManagedObjectContext, json: Input) -> Output
    static func loadAndStore(identifiedBy id: Identifier, config: LoadAndStoreConfiguration)
}

 extension Managed {
    static  var defaultSortDescriptors: [NSSortDescriptor] { return [] }
    
    static var sortedFetchRequest: NSFetchRequest<Self> {
        let request = NSFetchRequest<Self>(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        return request
    }

    public static func sortedFetchRequest(with predicate: NSPredicate) -> NSFetchRequest<Self> {
        let request = sortedFetchRequest
        request.predicate = predicate
        //print(predicate)
        return request
    }
}

extension Managed where Self: NSManagedObject {
    
    static var entityName: String { return entity().name!  }


    static func FindOrLoad(in context: NSManagedObjectContext, matching predicate: NSPredicate, load: () -> (Self)) -> Self {
        guard let object = findOrFetch(in: context, matching: predicate) else {
            let newObject = load()
            return newObject
        }
        return object
    }
    
    static func fetch(in context: NSManagedObjectContext, configurationBlock: (NSFetchRequest<Self>) -> () = { _ in }) -> [Self] {
        //print("fetch")
        let request = NSFetchRequest<Self>(entityName: Self.entityName)
        configurationBlock(request)
        return try! context.fetch(request)
    }
    
    static func findOrFetch(in context: NSManagedObjectContext, matching predicate: NSPredicate) -> Self? {
        //print("findOrFetch")
        guard let object = materializedObject(in: context, matching: predicate) else {
            return fetch(in: context) { request in
                request.predicate = predicate
                request.returnsObjectsAsFaults = false
                request.fetchLimit = 1
                }.first
        }
        return object
    }
    
    static func materializedObject(in context: NSManagedObjectContext, matching predicate: NSPredicate) -> Self? {
        for object in context.registeredObjects where !object.isFault {
            guard let result = object as? Self, predicate.evaluate(with: result) else { continue }
            return result
        }
        return nil
    }
}
