import UIKit
import AVFoundation
import CoreData

class ScannerController: UIViewController {
    
    var managedObjectContext: NSManagedObjectContext!
    var qrCode: String?
    var insertInProgress: Bool?
    
    @IBOutlet var messageLabel:UILabel!
    @IBOutlet var topbar: UIView!
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?

    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
                                        return UIStatusBarStyle.lightContent
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        insertInProgress = false

        let cameraDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        let captureDevice = cameraDiscoverySession.devices.first
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            captureSession.addInput(input)
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
        } catch {
            print(error)
            return
        }
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        captureSession.startRunning()
        
        view.bringSubview(toFront: messageLabel)
        view.bringSubview(toFront: topbar)
        
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }

    func launchApp(qrCode: String) {
        if presentedViewController != nil {
            return
        }
        
        let alertPrompt = UIAlertController(title: "Add Schedule", message: "\(qrCode)", preferredStyle: .actionSheet)
        let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            print("loading schedules ...")
            self.loadEntities(ofScheudle: qrCode)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        alertPrompt.addAction(confirmAction)
        alertPrompt.addAction(cancelAction)
        
        present(alertPrompt, animated: true, completion: nil)
    }
    
    func loadEntities(ofScheudle id: String) {
        insertInProgress = true
        let sv = UIViewController.displaySpinner(onView: self.view)
        var loadConfig = LoadAndStoreConfiguration()
        loadConfig.set(mainContext: managedObjectContext)
        
        Schedule.loadAndStore(identifiedBy: id, config: loadConfig)
        Venue.loadAndStore(identifiedBy: id, config: loadConfig)
        Track.loadAndStore(identifiedBy: id, config: loadConfig)
        Message.loadAndStore(identifiedBy: id, config: loadConfig)
        Category.loadAndStore(identifiedBy: id, config: loadConfig)
        
        loadConfig.group.notify(queue: .main) {
            Event.loadAndStore(identifiedBy: id, config: loadConfig)
            loadConfig.group.notify(queue: .main) {
                UIViewController.removeSpinner(spinner: sv)
                self.performSegue(withIdentifier: "unwindFromScanner", sender: self.qrCode)
            }
        }
    }
}

extension ScannerController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil && !insertInProgress! {
                qrCode = metadataObj.stringValue!
                launchApp(qrCode: qrCode!)
                //messageLabel.text = metadataObj.stringValue!
            }
        }
    }
}
