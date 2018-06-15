import CoreData

extension NSManagedObjectContext {
    
    func insertObject<A: NSManagedObject>() -> A where A: Managed {
        guard let obj = NSEntityDescription.insertNewObject(forEntityName: A.entityName, into: self) as? A else { fatalError("Wrong object type") }
        return obj
    }
    
    func saveOrRollback() -> Bool {
        do {
            try save()
            print("SAVE")
            return true
        } catch {
            rollback()
            return false
        }
    }
    
    func performChanges(block: @escaping () -> ()) {
        perform {
            print("performChanges")
            block()
            _ = self.saveOrRollback()
        }
    }
}
