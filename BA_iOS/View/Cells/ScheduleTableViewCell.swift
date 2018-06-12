import UIKit

class ScheduleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    func configure(for schedule: Schedule) {
        title.text = schedule.name
        subtitle.text = ""
    }
}
