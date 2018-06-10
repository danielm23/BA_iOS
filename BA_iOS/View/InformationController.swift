import UIKit
import Foundation
import Down
import CoreData

class InformationController: UIViewController {
    
    var managedObjectContext: NSManagedObjectContext!

    var schedules: [Schedule]?
    var rightItem = UIBarButtonItem()
    let favoriteButton: UIButton = UIButton(type: .custom)
    
    @IBAction func infoButtonPressed(_ sender: Any) {
        print("pressed")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButton()
        
        
        guard let downView = try? DownView(frame: self.view.bounds, markdownString: markdownString, didLoadSuccessfully: {
            // Optional callback for loading finished
            print("Markdown was rendered.")
        }) else { return }
        view.addSubview(downView)
    }
    
    fileprivate func configureButton() {
        favoriteButton.setTitle("Infos", for: .normal)
        favoriteButton.addTarget(self, action: #selector(self.infoButtonPressed(_:)), for: .touchUpInside)
        rightItem = UIBarButtonItem(customView: favoriteButton)
        self.navigationItem.rightBarButtonItem = rightItem
        print("set button")
    }
    
    fileprivate let markdownString = """
    # Tag der offenen Tür

    Curabitur blandit tempus porttitor. Aenean lacinia bibendum nulla sed consectetur. Donec ullamcorper nulla non metus auctor fringilla. Nulla vitae elit libero, a pharetra augue. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit.
    
    
    ## Allgemeines
    
    - Curabitur blandit tempus porttitor.
    - Donec sed odio dui.
    - Nullam quis risus eget urna mollis ornare vel eu leo. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus.
    
    ## An- und Abreise
    
    Etiam porta sem malesuada magna mollis euismod. Nullam id dolor id nibh ultricies vehicula ut id elit. Nullam quis risus eget urna mollis ornare vel eu leo. Donec ullamcorper nulla non metus auctor fringilla. Maecenas sed diam eget risus varius blandit sit amet non magna. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus.
    """
    
}
