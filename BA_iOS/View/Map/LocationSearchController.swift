import UIKit
import CoreData
import Foundation
import MapKit

class LocationSearchController: UITableViewController {
    
    var results: [JsonGeoOverview] = []
    var handleMapSearchDelegate:MapController? = nil
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationSearchCell",
                                                 for: indexPath) as! LocationSearchCell
        cell.configure(for: results[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let venue = results[indexPath.row]
        if (venue.latitude != nil && venue.longitude != nil) {
            
            handleMapSearchDelegate?.selectedLocation = results[indexPath.row]
            //handleMapSearchDelegate?.chooseButtonStatus()
            handleMapSearchDelegate?.showOnMap(location: venue)
            
            dismiss(animated: true, completion: nil)
        }
        else { print("no coordinates") }
    }
}

extension LocationSearchController {
    
    func getQueryString(for input: String) -> String {
        let queryString = input
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: "_")
        return queryString
    }
    
    func search(for searchTerm: String) {
        
        let config = LoadAndStoreConfiguration()
        config.group.enter()
        
        Webservice().load(resource: JsonGeoOverview.get(resultsFor: searchTerm), session: config.session) {
            locations in if locations != nil { // maybe use guard
                for location in locations! {
                    self.results.append(location)
                }
            }
            config.group.leave()
        }
        config.group.notify(queue: .main) {
            self.tableView.reloadData()
        }
    }
}
    
extension LocationSearchController : UISearchResultsUpdating {
        
    func updateSearchResults(for searchController: UISearchController) {
        // TODO: show live results
    }
}

extension LocationSearchController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        results.removeAll()
        if let enteredText = searchBar.text {
            search(for: getQueryString(for: enteredText))
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        results.removeAll()
        tableView.reloadData()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        results.removeAll()
        tableView.reloadData()
        return true
    }
}
