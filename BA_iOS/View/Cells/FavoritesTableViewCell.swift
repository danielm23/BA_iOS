import UIKit

class FavoritesTableViewCell: UITableViewCell{
    
    //@IBOutlet weak var title: UILabel!
    //@IBOutlet weak var subtitle: UILabel!
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    
    func configure(item: Favorites) {
        let timeFormatter = DateFormatter()
        let dateFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        dateFormatter.dateFormat = "dd.MM.yyyy"
        title?.text = item.event.name
        subtitle?.text = dateFormatter.string(from: item.created!)
    }
}
