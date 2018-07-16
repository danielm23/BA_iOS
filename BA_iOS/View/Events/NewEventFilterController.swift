//
//  NewEventFilterController.swift
//  BA_iOS
//
//  Created by Daniel Müller on 11.07.18.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class NewFilterController: UITableViewController {
    
    var managedObjectContext: NSManagedObjectContext!
    var schedules: [Schedule]?
    var categories: [Category]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if managedObjectContext == nil {
            managedObjectContext = (self.tabBarController as! TabBarController).managedObjectContext
        }
        
        loadSchedules()
        loadCategories()
    }
    
    func loadSchedules() {
        let scheduleRequest = Schedule.sortedFetchRequest
        scheduleRequest.fetchBatchSize = 20
        scheduleRequest.returnsObjectsAsFaults = false
        schedules = try! managedObjectContext.fetch(scheduleRequest)
    }
    
    func loadCategories() {
        let categoryRequest = Category.sortedFetchRequest
        categoryRequest.fetchBatchSize = 20
        categoryRequest.returnsObjectsAsFaults = false
        categories = try! managedObjectContext.fetch(categoryRequest)
    }
    
    
    
    private enum Section: Int {
        case schedule, category
        
        init?(indexPath: NSIndexPath) {
            self.init(rawValue: indexPath.section)
        }
        
        static var numberOfSections: Int { return 2 }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleFilterCell") as? ScheduleFilterTableViewCell
        
        switch Section(indexPath: indexPath as NSIndexPath) {
        case .schedule?: cell?.configure(withSchedule: schedules![indexPath.row])
        case .category?: cell?.configure(withCategory: categories![indexPath.row])
        case .none: break
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .schedule?: return (schedules?.count)!
        case .category?: return (categories?.count)!
        case .none: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Section(rawValue: section) {
        case .schedule?: return "Schedules"
        case .category?: return "Categories"
        case .none: return nil
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print("row: \(indexPath.row)")
        print("section: \(indexPath.section)")
        print("")
        let dispatchGroup = DispatchGroup()
        switch Section(indexPath: indexPath as NSIndexPath) {
        case .schedule?:
            dispatchGroup.enter()
            managedObjectContext.performChanges {
                self.schedules![indexPath.row].setActive()
                dispatchGroup.leave()
            }
            dispatchGroup.notify(queue: .main) {
                print("reload")
                tableView.reloadData()
            }
        case .category?:
            dispatchGroup.enter()
            managedObjectContext.performChanges {
                self.categories![indexPath.row].setActive()
                dispatchGroup.leave()
            }
            dispatchGroup.notify(queue: .main) {
                print("reload")
                tableView.reloadData()
            }
            
        case .none: break
        }
    }
    //dataSource.selectedObject?.setActive()
    //try managedObjectContext.save()
    //tableView.reloadData()
    //print("saved")
}
