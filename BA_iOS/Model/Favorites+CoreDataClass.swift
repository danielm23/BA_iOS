//
//  Favorites+CoreDataClass.swift
//  
//
//  Created by Daniel Müller on 23.04.18.
//
//

import Foundation
import CoreData

@objc(Favorites)
public class Favorites: NSManagedObject {
    
    func configure(event: PersistantEvent, number: Int) {
        self.event = event
        self.number = Int16(number)
        self.created = Date()
    }
}
