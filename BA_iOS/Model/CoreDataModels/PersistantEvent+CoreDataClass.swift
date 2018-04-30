//
//  PersistantEvent+CoreDataClass.swift
//  QRCodeReader
//
//  Created by Daniel Müller on 14.04.18.
//  Copyright © 2018 AppCoda. All rights reserved.
//
//

import Foundation
import CoreData

@objc(PersistantEvent)
public class PersistantEvent: NSManagedObject {
    
    func configure(event: Event) {
        self.id = Int32(event.id)
        self.name = event.name
        self.info = event.info
        self.startDate = event.startDate
        self.endDate = event.endDate
        self.isActive = event.isActive
        self.venueId = Int32(event.venueId)
        self.scheduleId = event.scheduleId
    }
    /*
    init() {
        super.init()
            id = 1
            name = ""
            info = ""
            startDate = Date()
            endDate = Date()
            self.isActive = true
            self.venueId = 1
            self.scheduleId = ""
        }*/
}
