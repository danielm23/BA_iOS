import CoreData

func createCDContainer(completion: @escaping (NSPersistentContainer) -> ()) {
    print("createCDContainer")
    let container = NSPersistentContainer(name: "CDModel")
    container.loadPersistentStores { _, error in
        guard error == nil else { fatalError("Failed to load store: \(error!)") }
        DispatchQueue.main.async { completion(container) }
    }
}


