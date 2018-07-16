import UIKit

class ScheduleFilterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    
    func configure(withCategory category: Category) {
        title?.text = category.title
        if category.isActive {
            self.accessoryType = .checkmark
        }
        else {
            self.accessoryType = .none
        }
    }
    
    func configure(withSchedule schedule: Schedule) {
        title?.text = schedule.name
        if schedule.isActive {
            self.accessoryType = .checkmark
        }
        else {
            self.accessoryType = .none
        }
    }
    
}
