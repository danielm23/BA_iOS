import UIKit

class EventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    func configure(item: PersistantEvent) {
        let timeFormatter = DateFormatter()
        let dateFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        dateFormatter.dateFormat = "dd.MM.yyyy"
        title?.text = item.name
        subtitle?.text = dateFormatter.string(from: item.startDate!) + ", " + timeFormatter.string(from: item.startDate!) + " bis " + timeFormatter.string(from: item.endDate!) + "Uhr"
    }
}
