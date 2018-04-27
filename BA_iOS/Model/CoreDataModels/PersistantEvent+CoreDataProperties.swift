//
//  PersistantEvent+CoreDataProperties.swift
//  
//
//  Created by Daniel Müller on 18.04.18.
//
//

import Foundation
import CoreData


extension PersistantEvent {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<PersistantEvent> {
        return NSFetchRequest<PersistantEvent>(entityName: "PersistantEvent")
    }

    @NSManaged public var endDate: Date?
    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var scheduleId: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var venueId: Int32
    @NSManaged public var info: String?
    @NSManaged public var isActive: Bool

}
