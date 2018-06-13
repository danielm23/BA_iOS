import Foundation
import UIKit
import CoreMotion

class ScheduleCollectionViewCell: BaseRoundedCardCell {
    
    @IBOutlet weak var cornerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var label: UILabel!
    
    func configure(for schedule: Schedule) {
        label.text = schedule.name
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cornerView.layer.cornerRadius = 14.0
        cornerView.clipsToBounds = true
    }
}
