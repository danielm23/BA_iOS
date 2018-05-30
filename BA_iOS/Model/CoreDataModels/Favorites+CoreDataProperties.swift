//
//  Favorites+CoreDataProperties.swift
//  
//
//  Created by Daniel Müller on 23.04.18.
//
//

import Foundation
import CoreData


extension Favorites {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Favorites> {
        return NSFetchRequest<Favorites>(entityName: "Favorites")
    }

    @NSManaged public var number: Int16
    @NSManaged public var created: Date?
    @NSManaged public var event: Event

}
