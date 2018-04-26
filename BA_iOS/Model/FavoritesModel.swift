//
//  FavoriteModel.swift
//  QRCodeReader
//
//  Created by Daniel Müller on 22.04.18.
//  Copyright © 2018 AppCoda. All rights reserved.
//

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
        let sort = NSSortDescriptor(key: "number", ascending: true)
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
        print(favoriteEvents.value)
        print("<-fetchObservableData()")
        return favoriteEvents.asObservable()
    }
    
    
    func storeNewEvents(newFavorite: PersistantEvent, orderNumber: Int) {
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        DispatchQueue.main.async { [unowned self] in
                let entity = NSEntityDescription.entity(forEntityName: "Favorites", in: self.context)
                let favorite = Favorites(entity: entity!, insertInto: self.context)
            print("storeNewEvents()")
                print(newFavorite)
                favorite.configure(event: newFavorite, number: orderNumber)
                print(favorite)
            }
            print("<- stored Event")
            self.appDelegate.saveContext()
            self.favoriteEvents.value = self.fetchData()
        }
    }

