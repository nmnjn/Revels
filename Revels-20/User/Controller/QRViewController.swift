
import AVFoundation
import UIKit
import Alamofire

class QRViewController: UIViewController, QRCodeReaderViewControllerDelegate {
    
    private var themedStatusBarStyle: UIStatusBarStyle?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return themedStatusBarStyle ?? UIStatusBarStyle.lightContent
    }
    
    func updateStatusBar(){
        themedStatusBarStyle = .lightContent
        setNeedsStatusBarAppearanceUpdate()
    }
    
    var memId: String?
    var eventId: Int?
    
    lazy var addUserButton: LoadingButton = {
        let button = LoadingButton()
        button.isEnabled = false
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.setTitle("", for: .normal)
        button.addTarget(self, action: #selector(markPresent), for: .touchUpInside)
        return button
    }()
    
    lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.setTitle("Dismiss", for: .normal)
        button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        return button
    }()
    
    lazy var memIdLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Scan Team Mate's ID"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    
    lazy var previewView: QRCodeReaderView = {
        let view = QRCodeReaderView()
        view.backgroundColor = .black
        view.setupComponents(with: QRCodeReaderViewControllerBuilder{
            $0.reader                 = reader
            $0.showTorchButton        = false
            $0.showSwitchCameraButton = false
            $0.showCancelButton       = false
            $0.showOverlayView        = true
            $0.rectOfInterest         = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
        })
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 14
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var reader: QRCodeReader = QRCodeReader()
    lazy var readerVC: QRCodeReaderViewController = {
    let builder = QRCodeReaderViewControllerBuilder {
        $0.reader                  = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
        $0.showTorchButton         = true
        $0.preferredStatusBarStyle = .lightContent
        $0.showOverlayView        = true
        $0.rectOfInterest          = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
      
        $0.reader.stopScanningWhenCodeIsFound = false
    }
        return QRCodeReaderViewController(builder: builder)
    }()

  // MARK: - Actions
    override func viewDidLoad() {
        super.viewDidLoad()
        updateStatusBar()
        setupViews()
        scanInPreviewAction()
    }
    
    func setupViews(){
        
        view.backgroundColor = UIColor.CustomColors.Black.background
        view.addSubview(previewView)
        view.addSubview(dismissButton)
        view.addSubview(memIdLabel)
        view.addSubview(addUserButton)
        
        previewView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        previewView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        previewView.heightAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
        previewView.widthAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
        
        _ = memIdLabel.anchor(top: nil, left: view.leftAnchor, bottom: previewView.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 32, rightConstant: 12, widthConstant: 0, heightConstant: 0)
        
        _ = addUserButton.anchor(top: nil, left: view.leftAnchor, bottom: memIdLabel.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 32, rightConstant: 12, widthConstant: 0, heightConstant: 50)
        
        _ = dismissButton.anchor(top: previewView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 32, leftConstant: 32, bottomConstant: 16, rightConstant: 32, widthConstant: 0, heightConstant: 40)
    }
    
    @objc private func addToTeamFor(Event: Int, TeamMate: String){
        addUserButton.showLoading()
        addUserButton.isEnabled = false
        addUserButton.activityIndicator.tintColor = .white
        Networking.sharedInstance.addTeamMateToEventWith(EventID: Event, TeamMateDelegateID: TeamMate, successCompletion: { (successMessage) in
            self.addUserButton.hideLoading()
            print(successMessage)
            FloatingMessage().longFloatingMessage(Message: "Successfully added Participant to your Team", Color: UIColor.CustomColors.Blue.register, onPresentation: {}) {
                self.resetScanner()
            }
        }) { (errorMessage) in
            print(errorMessage)
            if errorMessage == "User already registered for event" {
                FloatingMessage().floatingMessage(Message: "Team Mate has already registered for event!", Color: .orange, onPresentation: {}) {
                    self.resetScanner()
                }
            }else if errorMessage == "Card for event not bought"{
                FloatingMessage().floatingMessage(Message: "Team Mate has not bought the required delegate card.", Color: .red, onPresentation: {}) {
                    self.resetScanner()
                }
            }else{
                FloatingMessage().floatingMessage(Message: errorMessage, Color: .red, onPresentation: {}) {
                    self.resetScanner()
                }
            }
        }
    }
    
    func resetScanner(){
        self.scanInPreviewAction()
        self.memIdLabel.text = "Scan Team Mate's ID"
        self.addUserButton.isEnabled = true
        self.addUserButton.hideLoading()
    }
    
    @objc private func markPresent(){
        guard let event = self.eventId else { return }
        guard let mem = self.memId else {
            FloatingMessage().floatingMessage(Message: "Please Scan Member ID", Color: .red, onPresentation: {}) {
            }
            return
        }
        self.addToTeamFor(Event: event, TeamMate: mem)
    }
    
    @objc private func dismissVC(){
        self.dismiss(animated: true, completion: nil)
    }
    

  private func checkScanPermissions() -> Bool {
    do {
      return try QRCodeReader.supportsMetadataObjectTypes()
    } catch let error as NSError {
      let alert: UIAlertController

      switch error.code {
      case -11852:
        alert = UIAlertController(title: "Error", message: "This app is not authorized to use Back Camera.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
          DispatchQueue.main.async {
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
          }
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
      default:
        alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
      }

      present(alert, animated: true, completion: nil)

      return false
    }
  }

    func scanInPreviewAction() {
    guard checkScanPermissions(), !reader.isRunning else { return }

    reader.didFindCode = { result in
        self.memIdLabel.text = "ID Scanned Successfully"
        self.memId = "\(result.value.replacingOccurrences(of: " ", with: "+"))"
//        self.memId?.replacingOccurrences(of: " ", with: "+")
        print(self.memId)
//      print("Completion with result: \(result.value) of type \(result.metadataType)")
        guard let event = self.eventId else { return }
        self.addToTeamFor(Event: event, TeamMate: result.value)
    }

    reader.startScanning()
  }

  // MARK: - QRCodeReader Delegate Methods

  func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
    reader.stopScanning()

    dismiss(animated: true) { [weak self] in
      let alert = UIAlertController(
        title: "QRCodeReader",
        message: String (format:"%@ (of type %@)", result.value, result.metadataType),
        preferredStyle: .alert
      )
      alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

      self?.present(alert, animated: true, completion: nil)
    }
  }

  func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
    print("Switching capture to: \(newCaptureDevice.device.localizedName)")
  }

  func readerDidCancel(_ reader: QRCodeReaderViewController) {
    reader.stopScanning()

    dismiss(animated: true, completion: nil)
  }
}
