import Foundation
import UIKit
import RxSwift
import RxCocoa

class EventDetailController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var eventDetailViewModel = EventDetailViewModel()
    var disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = eventDetailViewModel.event.name
        setupFavoriteButton()
        button.setTitle(eventDetailViewModel.getButtonText(), for: .normal)
    }
    
    private func setupFavoriteButton() {
        button.rx.tap
            .subscribe(onNext : { [weak self] _ in
                self?.eventDetailViewModel.configureButton()
                self?.button.setTitle(self?.eventDetailViewModel.getButtonText(), for: .normal)
            })
            .disposed(by: disposeBag)
    }
}
