////
////  SignUpViewController.swift
////  TechTetva-19
////
////  Created by Naman Jain on 27/09/19.
////  Copyright © 2019 Naman Jain. All rights reserved.
////
//
//import UIKit
//
//
//struct RegisterResponse: Decodable{
//    let success: Bool
//    let msg: String
//}
//
//
//class SignUpViewController: UIViewController, UITextFieldDelegate{
//
//    var loginViewController: LoginViewController?
//
//    lazy var logoImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: "logo_dark-1")
//        imageView.contentMode = .scaleAspectFit
//        return imageView
//    }()
//
//    lazy var nameField: LeftPaddedTextField = {
//        let textField = LeftPaddedTextField()
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        return textField
//    }()
//
//    lazy var emailField: LeftPaddedTextField = {
//        let textField = LeftPaddedTextField()
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        return textField
//    }()
//
//    lazy var phoneField: LeftPaddedTextField = {
//        let textField = LeftPaddedTextField()
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        return textField
//    }()
//
//    lazy var collegeField: LeftPaddedTextField = {
//        let textField = LeftPaddedTextField()
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        return textField
//    }()
//
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        if textField == collegeField {
//            hideKeyboard()
//            collegeField.text = "Hello"
//            print("colllege field tapped")
//            return false
//        }
//        return true
//    }
//
//
//    lazy var regField: LeftPaddedTextField = {
//        let textField = LeftPaddedTextField()
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        return textField
//    }()
//
//    lazy var passwordField: LeftPaddedTextField = {
//        let textField = LeftPaddedTextField()
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        return textField
//    }()
//
//    lazy var registerButton: LoadingButton = {
//        let button = LoadingButton(type: .system)
//        button.setTitle("Register", for: UIControl.State())
//        button.backgroundColor = UIColor.CustomColors.Blue.logoDarkGreen
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitleColor(UIColor.white, for: UIControl.State())
//        if isSmalliPhone(){
//            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
//        }else{
//            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
//        }
//        button.layer.cornerRadius = 10
//        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
//        return button
//    }()
//
//    lazy var guestButton: LoadingButton = {
//        let button = LoadingButton(type: .system)
//        button.setTitle("Continue as Guest", for: UIControl.State())
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitleColor(UIColor.CustomColors.Blue.logoLightGreen, for: UIControl.State())
//        if isSmalliPhone(){
//            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
//        }else{
//            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
//        }
//        button.layer.cornerRadius = 10
//        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
//        return button
//    }()
//
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = UIColor.CustomColors.Black.background
//        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
//        observeKeyboardNotifications()
//        setupViews()
//    }
//
//    func setupViews(){
//
//        nameField.configure(color: .white,
//                             font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18),
//                             cornerRadius: isSmalliPhone() ? 20 : 25,
//                             borderColor: UIColor.CustomColors.Blue.logoDarkGreen,
//                             backgroundColor: UIColor.CustomColors.Black.background,
//                             borderWidth: 1.0)
//        nameField.keyboardType = .default
//        nameField.autocorrectionType = .no
//        nameField.clipsToBounds = true
//        nameField.delegate = self
//        nameField.tag = 0
//        nameField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [
//            .foregroundColor: UIColor.lightGray,
//            .font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18)
//            ])
//
//        emailField.configure(color: .white,
//                             font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18),
//                             cornerRadius: isSmalliPhone() ? 20 : 25,
//                             borderColor: UIColor.CustomColors.Blue.logoDarkGreen,
//                             backgroundColor: UIColor.CustomColors.Black.background,
//                             borderWidth: 1.0)
//        emailField.keyboardType = .emailAddress
//        emailField.autocorrectionType = .no
//        emailField.autocapitalizationType = .none
//        emailField.clipsToBounds = true
//        emailField.delegate = self
//        emailField.tag = 1
//        emailField.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [
//            .foregroundColor: UIColor.lightGray,
//            .font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18)
//            ])
//
//        phoneField.configure(color: .white,
//                             font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18),
//                             cornerRadius: isSmalliPhone() ? 20 : 25,
//                             borderColor: UIColor.CustomColors.Blue.logoDarkGreen,
//                             backgroundColor: UIColor.CustomColors.Black.background,
//                             borderWidth: 1.0)
//        phoneField.keyboardType = .phonePad
//        phoneField.autocorrectionType = .no
//        phoneField.autocapitalizationType = .none
//        phoneField.clipsToBounds = true
//        phoneField.delegate = self
//        phoneField.tag = 2
//        phoneField.attributedPlaceholder = NSAttributedString(string: "Phone Number", attributes: [
//            .foregroundColor: UIColor.lightGray,
//            .font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18)
//            ])
//
//        collegeField.configure(color: .white,
//                            font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18),
//                            cornerRadius: isSmalliPhone() ? 20 : 25,
//                            borderColor: UIColor.CustomColors.Blue.logoDarkGreen,
//                            backgroundColor: UIColor.CustomColors.Black.background,
//                            borderWidth: 1.0)
//        collegeField.keyboardType = .default
//        collegeField.autocorrectionType = .no
//        collegeField.clipsToBounds = true
//        collegeField.delegate = self
//        collegeField.tag = 3
//        collegeField.attributedPlaceholder = NSAttributedString(string: "College Name", attributes: [
//            .foregroundColor: UIColor.lightGray,
//            .font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18)
//            ])
//
//        regField.configure(color: .white,
//                            font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18),
//                            cornerRadius: isSmalliPhone() ? 20 : 25,
//                            borderColor: UIColor.CustomColors.Blue.logoDarkGreen,
//                            backgroundColor: UIColor.CustomColors.Black.background,
//                            borderWidth: 1.0)
//        regField.keyboardType = .default
//        regField.autocorrectionType = .no
//        regField.clipsToBounds = true
//        regField.delegate = self
//        regField.tag = 4
//        regField.attributedPlaceholder = NSAttributedString(string: "Reg No./Faculty ID", attributes: [
//            .foregroundColor: UIColor.lightGray,
//            .font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18)
//            ])
//
//
//        let discloseImageView = UIImageView()
//        discloseImageView.image = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
//        discloseImageView.tintColor = .white
//        discloseImageView.contentMode = .scaleAspectFit
//
//
//        if isSmalliPhone(){
//            view.addSubview(logoImageView)
//            _ = logoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 32, bottomConstant: 32, rightConstant: 32, widthConstant: 70, heightConstant: 70)
//            view.addSubview(nameField)
//            _ = nameField.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 40)
//            view.addSubview(emailField)
//            _ = emailField.anchor(top: nameField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 40)
//            view.addSubview(phoneField)
//            _ = phoneField.anchor(top: emailField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 40)
//            view.addSubview(collegeField)
//            _ = collegeField.anchor(top: phoneField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 40)
//            view.addSubview(regField)
//            _ = regField.anchor(top: collegeField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 40)
//
//            view.addSubview(guestButton)
//            _ = guestButton.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 32, bottomConstant: 16, rightConstant: 32, widthConstant: 0, heightConstant: 30)
//
//            view.addSubview(registerButton)
//            _ = registerButton.anchor(top: nil, left: view.leftAnchor, bottom: guestButton.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 32, bottomConstant: 8, rightConstant: 32, widthConstant: 0, heightConstant: 40)
//
//        }else{
//            view.addSubview(logoImageView)
//            _ = logoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 32, leftConstant: 32, bottomConstant: 32, rightConstant: 32, widthConstant: 100, heightConstant: 100)
//            view.addSubview(nameField)
//            _ = nameField.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 48, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 50)
//            view.addSubview(emailField)
//            _ = emailField.anchor(top: nameField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 50)
//            view.addSubview(phoneField)
//            _ = phoneField.anchor(top: emailField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 50)
//            view.addSubview(collegeField)
//            _ = collegeField.anchor(top: phoneField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 50)
//
//            collegeField.addSubview(discloseImageView)
//            _ = discloseImageView.anchor(top: collegeField.topAnchor, left: nil, bottom: collegeField.bottomAnchor, right: collegeField.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 16, rightConstant: 16, widthConstant: 25, heightConstant: 0)
//            view.addSubview(regField)
//            _ = regField.anchor(top: collegeField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 50)
//
//            view.addSubview(guestButton)
//            _ = guestButton.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 32, bottomConstant: 16, rightConstant: 32, widthConstant: 0, heightConstant: 30)
//
//            view.addSubview(registerButton)
//            _ = registerButton.anchor(top: nil, left: view.leftAnchor, bottom: guestButton.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 32, bottomConstant: 16, rightConstant: 32, widthConstant: 0, heightConstant: 50)
//
//        }
//    }
//
//    fileprivate func observeKeyboardNotifications() {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
//    }
//
//
//    @objc func hideKeyboard(){
//        view.endEditing(true)
//    }
//
//    @objc func keyboardHide() {
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
//            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
//            self.logoImageView.alpha = 1
//        }, completion: nil)
//    }
//
//    @objc func keyboardShow() {
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
//
//            var y: CGFloat = -90
//            if self.isSmalliPhone(){
//                y = -50
//            }
//            self.view.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: self.view.frame.height)
//            self.logoImageView.alpha = 0
//        }, completion: nil)
//    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        print(textField.tag)
//        switch textField.tag {
//        case 0:
//            emailField.becomeFirstResponder()
//            break
//        case 1:
//            phoneField.becomeFirstResponder()
//            break
//        case 2:
//            collegeField.becomeFirstResponder()
//            break
//        case 3:
//            regField.becomeFirstResponder()
//            break
//        case 4:
//            hideKeyboard()
//            break
//        default: break
//        }
//        return true
//    }
//
//    override var preferredStatusBarStyle : UIStatusBarStyle {
//        return .lightContent
//    }
//
//    @objc func handleDismiss(){
//        self.dismiss(animated: true)
//    }
//
//    @objc func handleRegister(){
//        guard let name = nameField.text else { return }
//        guard let email = emailField.text else { return }
//        guard let phone = phoneField.text else { return }
//        guard let college = collegeField.text else { return }
//        guard let regNo = regField.text else { return }
//
//        if name == ""{
//            FloatingMessage().floatingMessage(Message: "Please enter your Details", Color: .red, onPresentation: {
//                self.nameField.becomeFirstResponder()
//            }) {}
//            return
//        }
//
//        if email == ""{
//            FloatingMessage().floatingMessage(Message: "Please enter Email Address", Color: .red, onPresentation: {
//                self.emailField.becomeFirstResponder()
//            }) {}
//            return
//        }
//
//        if validateEmail(enteredEmail: email) == false{
//            FloatingMessage().floatingMessage(Message: "Invalid Email Address", Color: .red, onPresentation: {
//                self.emailField.becomeFirstResponder()
//            }) {}
//            return
//        }
//
//        if phone == ""{
//            FloatingMessage().floatingMessage(Message: "Please enter Phone Number", Color: .red, onPresentation: {
//                self.phoneField.becomeFirstResponder()
//            }) {}
//            return
//        }
//
//        if validatePhoneNumber(enteredNumber: phone) == false {
//            FloatingMessage().floatingMessage(Message: "Invalid Phone Number", Color: .red, onPresentation: {
//                self.phoneField.becomeFirstResponder()
//            }) {}
//            return
//        }
//
//        if college == ""{
//            FloatingMessage().floatingMessage(Message: "Please enter your College Name", Color: .red, onPresentation: {
//                self.collegeField.becomeFirstResponder()
//            }) {}
//            return
//        }
//
//        if regNo == ""{
//            FloatingMessage().floatingMessage(Message: "Please enter your Reg No./Faculty ID", Color: .red, onPresentation: {
//                self.regField.becomeFirstResponder()
//            }) {}
//            return
//        }
//
//        registerButton.showLoading()
//        registerButton.activityIndicator.color = .white
//
//        Networking.sharedInstance.registerUserWithDetails(name: name, email: email, mobile: phone, reg: regNo, collname: college, dataCompletion: { (successString) in
//            print(successString)
//            FloatingMessage().longFloatingMessage(Message: "A confirmation link has been sent to \(email).", Color: UIColor.CustomColors.Blue.register, onPresentation: {
//                self.hideKeyboard()
//            }) {
//                self.loginViewController?.emailField.text = email
//                self.navigationController?.popViewController(animated: true)
//            }
//            self.registerButton.hideLoading()
//        }) { (errorString) in
//            FloatingMessage().floatingMessage(Message: errorString, Color: .red, onPresentation: {
//            }) {}
//            print(errorString)
//            self.registerButton.hideLoading()
//            return
//        }
//    }
//
//    func validateEmail(enteredEmail: String) -> Bool {
//        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
//        return emailPredicate.evaluate(with: enteredEmail)
//    }
//
//    func validatePhoneNumber(enteredNumber: String) -> Bool {
//        let phoneNumberRegex = "^[6-9]\\d{9}$"
//        let phonePredicate = NSPredicate(format:"SELF MATCHES %@", phoneNumberRegex)
//        return phonePredicate.evaluate(with: enteredNumber)
//    }
//
//}


//
//  SignUpViewController.swift
//  TechTetva-19
//
//  Created by Naman Jain on 27/09/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit


struct RegisterResponse: Decodable{
    let success: Bool
    let msg: String
}


class SignUpViewController: UIViewController, UITextFieldDelegate{
    
    var loginViewController: LoginViewController?
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo_dark-1")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var nameField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var emailField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var phoneField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var collegeField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var regField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var passwordField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var registerButton: LoadingButton = {
        let button = LoadingButton(type: .system)
        button.setTitle("Register", for: UIControl.State())
        button.backgroundColor = UIColor.CustomColors.Blue.logoDarkGreen
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControl.State())
        if isSmalliPhone(){
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        }else{
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        }
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    lazy var guestButton: LoadingButton = {
        let button = LoadingButton(type: .system)
        button.setTitle("Continue as Guest", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.CustomColors.Blue.logoLightGreen, for: UIControl.State())
        if isSmalliPhone(){
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        }else{
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        }
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
   
    var collegeSearchearchController = collegeSearchTableViewController()
    var searchController = UISearchController()
    
    var colleges = [String]()
    var maheColleges = [String]()
    var filteredColleges = [String]()

    // MARK: - Table view data source
    func setupColleges(){
        let apiStruct = ApiStruct(url: collegeDataURL, method: .get, body: nil)
        WSManager.shared.getJSONResponse(apiStruct: apiStruct, success: { (map: collegeDataResponse) in
            if map.success{
                for i in map.data{
                    self.colleges.append(i.name)
                    if(i.MAHE == 1)
                    {
                        self.maheColleges.append(i.name)
                    }
                }
                self.colleges.sort()
                self.maheColleges.sort()
                self.filteredColleges = self.colleges
            }
        }) { (error) in
            print(error)
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == collegeField {
            hideKeyboard()
            collegeSearchearchController.collegeDelegate = self
            collegeSearchearchController.colleges = self.colleges
            collegeSearchearchController.maheColleges = self.maheColleges
            collegeSearchearchController.filteredColleges = self.filteredColleges
            searchController = UISearchController(searchResultsController: collegeSearchearchController)
            searchController.searchResultsUpdater = collegeSearchearchController
            searchController.searchBar.barStyle = .blackTranslucent
            searchController.searchBar.backgroundImage = UIImage.init(color: .clear)
            searchController.searchBar.barTintColor = .black
            searchController.dimsBackgroundDuringPresentation = false
            searchController.hidesNavigationBarDuringPresentation = false
        
            present(searchController, animated: true, completion: nil)
            searchController.searchResultsController?.view.isHidden = false
            return false
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.CustomColors.Black.background
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        observeKeyboardNotifications()
        setupViews()
        setupColleges()
    }
    
    func setupViews(){
        
        nameField.configure(color: .white,
                             font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18),
                             cornerRadius: isSmalliPhone() ? 20 : 25,
                             borderColor: UIColor.CustomColors.Blue.logoDarkGreen,
                             backgroundColor: UIColor.CustomColors.Black.background,
                             borderWidth: 1.0)
        nameField.keyboardType = .default
        nameField.autocorrectionType = .no
        nameField.clipsToBounds = true
        nameField.delegate = self
        nameField.tag = 0
        nameField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18)
            ])
        
        emailField.configure(color: .white,
                             font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18),
                             cornerRadius: isSmalliPhone() ? 20 : 25,
                             borderColor: UIColor.CustomColors.Blue.logoDarkGreen,
                             backgroundColor: UIColor.CustomColors.Black.background,
                             borderWidth: 1.0)
        emailField.keyboardType = .emailAddress
        emailField.autocorrectionType = .no
        emailField.autocapitalizationType = .none
        emailField.clipsToBounds = true
        emailField.delegate = self
        emailField.tag = 1
        emailField.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18)
            ])
        
        phoneField.configure(color: .white,
                             font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18),
                             cornerRadius: isSmalliPhone() ? 20 : 25,
                             borderColor: UIColor.CustomColors.Blue.logoDarkGreen,
                             backgroundColor: UIColor.CustomColors.Black.background,
                             borderWidth: 1.0)
        phoneField.keyboardType = .phonePad
        phoneField.autocorrectionType = .no
        phoneField.autocapitalizationType = .none
        phoneField.clipsToBounds = true
        phoneField.delegate = self
        phoneField.tag = 2
        phoneField.attributedPlaceholder = NSAttributedString(string: "Phone Number", attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18)
            ])
        
        collegeField.configure(color: .white,
                            font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18),
                            cornerRadius: isSmalliPhone() ? 20 : 25,
                            borderColor: UIColor.CustomColors.Blue.logoDarkGreen,
                            backgroundColor: UIColor.CustomColors.Black.background,
                            borderWidth: 1.0)
        collegeField.keyboardType = .default
        collegeField.autocorrectionType = .no
        collegeField.clipsToBounds = true
        collegeField.delegate = self
        collegeField.tag = 3
        collegeField.attributedPlaceholder = NSAttributedString(string: "College Name", attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18)
            ])
        
        regField.configure(color: .white,
                            font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18),
                            cornerRadius: isSmalliPhone() ? 20 : 25,
                            borderColor: UIColor.CustomColors.Blue.logoDarkGreen,
                            backgroundColor: UIColor.CustomColors.Black.background,
                            borderWidth: 1.0)
        regField.keyboardType = .default
        regField.autocorrectionType = .no
        regField.clipsToBounds = true
        regField.delegate = self
        regField.tag = 4
        regField.attributedPlaceholder = NSAttributedString(string: "Reg No./Faculty ID", attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18)
            ])
        
        
        if isSmalliPhone(){
            view.addSubview(logoImageView)
            _ = logoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 32, bottomConstant: 32, rightConstant: 32, widthConstant: 70, heightConstant: 70)
            view.addSubview(nameField)
            _ = nameField.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 40)
            view.addSubview(emailField)
            _ = emailField.anchor(top: nameField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 40)
            view.addSubview(phoneField)
            _ = phoneField.anchor(top: emailField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 40)
            view.addSubview(collegeField)
            _ = collegeField.anchor(top: phoneField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 40)
            view.addSubview(regField)
            _ = regField.anchor(top: collegeField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 40)
            
            view.addSubview(guestButton)
            _ = guestButton.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 32, bottomConstant: 16, rightConstant: 32, widthConstant: 0, heightConstant: 30)
            
            view.addSubview(registerButton)
            _ = registerButton.anchor(top: nil, left: view.leftAnchor, bottom: guestButton.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 32, bottomConstant: 8, rightConstant: 32, widthConstant: 0, heightConstant: 40)
            
        }else{
            view.addSubview(logoImageView)
            _ = logoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 32, leftConstant: 32, bottomConstant: 32, rightConstant: 32, widthConstant: 100, heightConstant: 100)
            view.addSubview(nameField)
            _ = nameField.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 48, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 50)
            view.addSubview(emailField)
            _ = emailField.anchor(top: nameField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 50)
            view.addSubview(phoneField)
            _ = phoneField.anchor(top: emailField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 50)
            view.addSubview(collegeField)
            _ = collegeField.anchor(top: phoneField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 50)
            view.addSubview(regField)
            _ = regField.anchor(top: collegeField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 50)
            
            view.addSubview(guestButton)
            _ = guestButton.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 32, bottomConstant: 16, rightConstant: 32, widthConstant: 0, heightConstant: 30)
            
            view.addSubview(registerButton)
            _ = registerButton.anchor(top: nil, left: view.leftAnchor, bottom: guestButton.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 32, bottomConstant: 16, rightConstant: 32, widthConstant: 0, heightConstant: 50)
            
        }
    }
    
    fileprivate func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    @objc func keyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            self.logoImageView.alpha = 1
        }, completion: nil)
    }
    
    @objc func keyboardShow() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            
            var y: CGFloat = -90
            if self.isSmalliPhone(){
                y = -50
            }
            self.view.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: self.view.frame.height)
            self.logoImageView.alpha = 0
        }, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(textField.tag)
        switch textField.tag {
        case 0:
            emailField.becomeFirstResponder()
            break
        case 1:
            phoneField.becomeFirstResponder()
            break
        case 2:
            collegeField.becomeFirstResponder()
            break
        case 3:
            regField.becomeFirstResponder()
            break
        case 4:
            hideKeyboard()
            break
        default: break
        }
        return true
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func handleDismiss(){
        self.dismiss(animated: true)
    }
    
    @objc func handleRegister(){
        guard let name = nameField.text else { return }
        guard let email = emailField.text else { return }
        guard let phone = phoneField.text else { return }
        guard let college = collegeField.text else { return }
        guard let regNo = regField.text else { return }
        
        if name == ""{
            FloatingMessage().floatingMessage(Message: "Please enter your Details", Color: .red, onPresentation: {
                self.nameField.becomeFirstResponder()
            }) {}
            return
        }
        
        if email == ""{
            FloatingMessage().floatingMessage(Message: "Please enter Email Address", Color: .red, onPresentation: {
                self.emailField.becomeFirstResponder()
            }) {}
            return
        }
        
        if validateEmail(enteredEmail: email) == false{
            FloatingMessage().floatingMessage(Message: "Invalid Email Address", Color: .red, onPresentation: {
                self.emailField.becomeFirstResponder()
            }) {}
            return
        }
        
        if phone == ""{
            FloatingMessage().floatingMessage(Message: "Please enter Phone Number", Color: .red, onPresentation: {
                self.phoneField.becomeFirstResponder()
            }) {}
            return
        }
        
        if validatePhoneNumber(enteredNumber: phone) == false {
            FloatingMessage().floatingMessage(Message: "Invalid Phone Number", Color: .red, onPresentation: {
                self.phoneField.becomeFirstResponder()
            }) {}
            return
        }
        
        if college == ""{
            FloatingMessage().floatingMessage(Message: "Please enter your College Name", Color: .red, onPresentation: {
                self.collegeField.becomeFirstResponder()
            }) {}
            return
        }
        
        if regNo == ""{
            FloatingMessage().floatingMessage(Message: "Please enter your Reg No./Faculty ID", Color: .red, onPresentation: {
                self.regField.becomeFirstResponder()
            }) {}
            return
        }
        
        registerButton.showLoading()
        registerButton.activityIndicator.color = .white
        
        Networking.sharedInstance.registerUserWithDetails(name: name, email: email, mobile: phone, reg: regNo, collname: college, dataCompletion: { (successString) in
            print(successString)
            FloatingMessage().longFloatingMessage(Message: "A confirmation link has been sent to \(email).", Color: UIColor.CustomColors.Blue.register, onPresentation: {
                self.hideKeyboard()
            }) {
                self.loginViewController?.emailField.text = email
                self.navigationController?.popViewController(animated: true)
            }
            self.registerButton.hideLoading()
        }) { (errorString) in
            FloatingMessage().floatingMessage(Message: errorString, Color: .red, onPresentation: {
            }) {}
            print(errorString)
            self.registerButton.hideLoading()
            return
        }
    }
    
    func validateEmail(enteredEmail: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    func validatePhoneNumber(enteredNumber: String) -> Bool {
        let phoneNumberRegex = "^[6-9]\\d{9}$"
        let phonePredicate = NSPredicate(format:"SELF MATCHES %@", phoneNumberRegex)
        return phonePredicate.evaluate(with: enteredNumber)
    }
    
}


protocol collegeSelected
{
    func collegeTapped(name:String)
}

extension SignUpViewController: collegeSelected
{
    func collegeTapped(name: String) {
        
        searchController.dismiss(animated: true) {
            self.collegeField.text = name
            self.regField.becomeFirstResponder()
        }
        
//        searchController.dismiss(animated: false, completion: nil)
    }
}
