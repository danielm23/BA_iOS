import UIKit

class ScheduleFilterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    
    func configure(for schedule: Schedule) {
        title?.text = schedule.name
        if schedule.isActive {
            self.accessoryType = .checkmark
        }
        else {
            self.accessoryType = .none
        }
    }
}
