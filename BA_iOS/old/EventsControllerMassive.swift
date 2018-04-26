//
//  EventsControllerMassive.swift
//  QRCodeReader
//
//  Created by Daniel Müller on 15.04.18.
//  Copyright © 2018 AppCoda. All rights reserved.
//
/*
import Foundation
import UIKit
import CoreData

class EventsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // let dataModel = EventsDataModel()
    let dispatchGroup = DispatchGroup()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        loadSavedEvents()
    }
    
    @IBAction func unwind(_ seque: UIStoryboardSegue) {
        if let sourceVC = seque.source as? ScannerController {
            scheduleQrCode = sourceVC.qrCode
            dispatchGroup.enter()
            loadEventsOfSchedule(qrCode: scheduleQrCode!)
            dispatchGroup.notify(queue: .main) {
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storedEvents.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EventTableViewCell
        cell.configure(item: storedEvents[indexPath.row])
        return cell
    }
    
    func loadSavedEvents() {
        let request = PersistantEvent.createFetchRequest()
        let sort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sort]
        
        do {
            storedEvents = try context.fetch(request)
            print("Got \(storedEvents.count) events")
            tableView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }
    
    
    
    // AUSLAGERBAR:
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as!
        AppDelegate).persistentContainer.viewContext
    
    var scheduleQrCode: String? = ""
    //let dispatchGroup = DispatchGroup()
    
    var events: [Event] = []
    var storedEvents: [PersistantEvent] = []
    /*
     func loadSavedEvents() {
     let request = PersistantEvent.createFetchRequest()
     let sort = NSSortDescriptor(key: "name", ascending: true)
     request.sortDescriptors = [sort]
     
     do {
     storedEvents = try context.fetch(request)
     print("Got \(storedEvents.count) events")
     //tableView.reloadData()
     } catch {
     print("Fetch failed")
     }
     }*/
    
    func loadEventsOfSchedule(qrCode: String){
        let session = URLSession.shared
        let baseUrl : String = "https://danielmueller.fwd.wf/api"
        let schedulesRoute : String = "/schedules"
        let eventsRoute: String = "/events/"
        
        let requestUrl: String = baseUrl + schedulesRoute + "/" + qrCode + eventsRoute
        
        var errorMessage = ""
        let defaultSession = URLSession(configuration: .default)
        
        var dataTask: URLSessionDataTask?
        
        dataTask?.cancel()
        
        guard let url = URL(string: requestUrl) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        dataTask = defaultSession.dataTask(with: url) { data, response, error in
            
            defer {dataTask = nil}
            
            if let error = error {
                errorMessage += "DataTask error: " + error.localizedDescription + "\n"
            } else if let data = data,
                let response = response as? HTTPURLResponse, response.statusCode == 200 {
                do {
                    let newEvents = try JSONDecoder().decode([Event].self, from: data)
                    self.storeData(loadedEvents: newEvents)
                }
                catch let jsonErr {
                    print("Error json: ", jsonErr)
                }
            }
            self.dispatchGroup.leave()
        }
        dataTask?.resume()
    }
    
    func storeData(loadedEvents: [Event]) {
        DispatchQueue.main.async { [unowned self] in
            for newEvent in loadedEvents {
                let entity = NSEntityDescription.entity(forEntityName: "PersistantEvent", in: self.context)
                let persistantEvent = PersistantEvent(entity: entity!, insertInto: self.context)
                self.configureEvent(persistantEvent: persistantEvent, usingJSON: newEvent)
            }
            self.appDelegate.saveContext()
            self.loadSavedEvents()
        }
    }
    
    func configureEvent(persistantEvent: PersistantEvent, usingJSON event: Event) {
        persistantEvent.id = Int32(event.id)
        persistantEvent.name = event.name
        persistantEvent.startDate = event.startDate
        persistantEvent.endDate = event.endDate
        persistantEvent.scheduleId = event.scheduleId
        persistantEvent.venueId = Int32(event.venueId)
    }
}
*/
