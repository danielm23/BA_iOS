import UIKit

class LocationSearchCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    func configure(for result: JsonGeoOverview) {
        label?.text = result.title
    }
}
