import UIKit

class EventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var colorIndicator: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var rightSubtitle: UILabel!
    
    func configure(for event: Event) {
        let timeFormatter = DateFormatter()
        let dateFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        dateFormatter.dateFormat = "dd.MM.yyyy"
        if event.isFavorite {
            colorIndicator.backgroundColor = .blue
        }
        
        title?.text = event.name
        subtitle?.text = dateFormatter.string(from: event.startDate!) + ", " + timeFormatter.string(from: event.startDate!) + " bis " + timeFormatter.string(from: event.endDate!) + "Uhr"
        rightSubtitle?.text = event.venue?.name
    }
}
