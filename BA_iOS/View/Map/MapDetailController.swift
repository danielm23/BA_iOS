import Foundation
import UIKit
import MapKit
import CoreData
import CoreLocation

class MapDetailController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var navigationButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    var titleString: String?

    var handleNavigationButtonDelegate: MapController? = nil
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        handleNavigationButtonDelegate?.removeLocation()
        handleNavigationButtonDelegate?.removeInformationOverlay()
    }
    
    @IBAction func navigationButtonPressed(_ sender: Any) {
        switch navigationButton.state.rawValue {
        case 1:
            handleNavigationButtonDelegate?.clearRoute()
            navigationButton.isSelected = true
        default:
            handleNavigationButtonDelegate?.startNavigation()
            navigationButton.isSelected = false
        }
    }

    func configuresSelectedLocationButton() {
        navigationButton.setTitle("beenden", for: .normal)
        navigationButton.setTitle("starten", for: .selected)
        navigationButton.layer.borderWidth = 1.5
        navigationButton.layer.borderColor = navigationButton.tintColor.cgColor
        navigationButton.layer.cornerRadius = 5
        navigationButton.backgroundRect(forBounds: navigationButton.frame)
        navigationButton.isSelected = true
    }
    
    func configureCloseButton() {
        closeButton.setImage(UIImage(named: "cancel")?.withRenderingMode(.alwaysTemplate), for: .normal)
        closeButton.tintColor = view.tintColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addGestureRecognizer()
        configuresSelectedLocationButton()
        configureCloseButton()
        titleLabel.text = titleString
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureBackgroundView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateDetailView()
    }
    
    func animateDetailView() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            let frame = self?.view.frame
            let yPosition = UIScreen.main.bounds.height - 150
            self?.view.frame = CGRect(x:0, y: yPosition, width: frame!.width, height: frame!.height)
        }
    }
    
    func addGestureRecognizer() {
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGesture))
        view.addGestureRecognizer(gesture)
    }
    
    func configureBackgroundView(){
        let blurEffect = UIBlurEffect.init(style: .dark)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        let bluredView = UIVisualEffectView.init(effect: blurEffect)
        bluredView.contentView.addSubview(visualEffect)
        visualEffect.frame = UIScreen.main.bounds
        bluredView.frame = UIScreen.main.bounds
        view.insertSubview(bluredView, at: 0)
    }

    @objc func panGesture(recognizer: UIPanGestureRecognizer) {
        let y = self.view.frame.minY
        let upperLimitForViewPosition = CGFloat(1180)
        let lowerLimitForViewPosition = CGFloat(980)
        let translation = recognizer.translation(in: self.view)
        let newViewPostition = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
        
        if (lowerLimitForViewPosition <= newViewPostition.maxY &&
            newViewPostition.maxY <= upperLimitForViewPosition) {
            self.view.frame = newViewPostition
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
    }
}
