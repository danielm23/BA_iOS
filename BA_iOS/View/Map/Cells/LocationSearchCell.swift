import UIKit

class LocationSearchCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var subtitle: UILabel!
    
    
    func configure(for result: JsonGeoOverview) {
        label?.text = result.title
        subtitle.text = "" // replace with building/parent
    }
}
