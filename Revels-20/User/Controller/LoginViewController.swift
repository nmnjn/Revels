//
//  LoginViewController.swift
//  TechTetva-19
//
//  Created by Naman Jain on 28/08/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit
import FirebaseMessaging

class LoginViewController: UIViewController, UITextFieldDelegate{
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo_dark-1")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var emailField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var passwordField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    

    lazy var loginButton: LoadingButton = {
        let button = LoadingButton(type: .system)
        button.backgroundColor = UIColor.CustomColors.Blue.logoDarkGreen
        button.setTitle("Login", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControl.State())
        if isSmalliPhone(){
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        }else{
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        }
        button.layer.cornerRadius = isSmalliPhone() ? 20 : 25
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()

    lazy var registerButton: LoadingButton = {
        let button = LoadingButton(type: .system)
        button.setTitle("Register", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControl.State())
        if isSmalliPhone(){
           button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        }else{
           button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        }
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.CustomColors.Blue.logoDarkGreen.cgColor
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
    
    lazy var forgotPasswordButton: LoadingButton = {
        let button = LoadingButton(type: .system)
        button.setTitle("Forgot Password?", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.CustomColors.Blue.logoLightGreen, for: UIControl.State())
        if isSmalliPhone(){
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        }else{
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        }
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.CustomColors.Black.background
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        observeKeyboardNotifications()
        setupViews()
    }
    func setupViews(){
        passwordField.configure(color: .white,
                                font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18),
                                cornerRadius: isSmalliPhone() ? 20 : 25,
                                borderColor: UIColor.CustomColors.Blue.logoDarkGreen,
                                backgroundColor: UIColor.CustomColors.Black.background,
                                borderWidth: 1.0)
        passwordField.isSecureTextEntry = true
        passwordField.clipsToBounds = true
        passwordField.delegate = self
        passwordField.tag = 1
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [
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
        emailField.placeholder = "Email Address"
        emailField.clipsToBounds = true
        emailField.delegate = self
        emailField.tag = 0
        emailField.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [
                .foregroundColor: UIColor.lightGray,
                .font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18)
            ])

        
        if isSmalliPhone(){
            view.addSubview(logoImageView)
            _ = logoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 32, bottomConstant: 32, rightConstant: 32, widthConstant: 70, heightConstant: 70)
            view.addSubview(emailField)
            _ = emailField.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 48, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 40)
            view.addSubview(passwordField)
            _ = passwordField.anchor(top: emailField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 40)
            
            view.addSubview(loginButton)
            _ = loginButton.anchor(top: passwordField.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 16, leftConstant: 48, bottomConstant: 16, rightConstant: 48, widthConstant: 120, heightConstant: 40)
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
            view.addSubview(forgotPasswordButton)
            _ = forgotPasswordButton.anchor(top: loginButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 40)
            
            view.addSubview(guestButton)
            _ = guestButton.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 32, bottomConstant: 16, rightConstant: 32, widthConstant: 0, heightConstant: 30)

            view.addSubview(registerButton)
            _ = registerButton.anchor(top: nil, left: view.leftAnchor, bottom: guestButton.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 32, bottomConstant: 16, rightConstant: 32, widthConstant: 0, heightConstant: 40)

        }else{
            view.addSubview(logoImageView)
            _ = logoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 64, leftConstant: 32, bottomConstant: 32, rightConstant: 32, widthConstant: 150, heightConstant: 150)
            view.addSubview(emailField)
            _ = emailField.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 48, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 50)
            view.addSubview(passwordField)
            _ = passwordField.anchor(top: emailField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 50)
            
            view.addSubview(loginButton)
            _ = loginButton.anchor(top: passwordField.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 32, leftConstant: 64, bottomConstant: 16, rightConstant: 64, widthConstant: 150, heightConstant: 50)
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
            view.addSubview(forgotPasswordButton)
            _ = forgotPasswordButton.anchor(top: loginButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 40)
            
            view.addSubview(guestButton)
            _ = guestButton.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 32, bottomConstant: 16, rightConstant: 32, widthConstant: 0, heightConstant: 30)

            view.addSubview(registerButton)
            _ = registerButton.anchor(top: nil, left: view.leftAnchor, bottom: guestButton.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 32, bottomConstant: 16, rightConstant: 32, widthConstant: 0, heightConstant: 50)

//            view.addSubview(loginButton)
//            _ = loginButton.anchor(top: nil, left: view.leftAnchor, bottom: registerButton.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 32, bottomConstant: 16, rightConstant: 32, widthConstant: 0, heightConstant: 50)
        }
    }

    fileprivate func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        if textField.tag == 0{
            passwordField.becomeFirstResponder()
        }else{
            hideKeyboard()
        }
        return true
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }

    @objc func handleLogin(){
        
        guard let email = emailField.text else { return }
        
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
        
        guard let password = passwordField.text else { return }
        
        if password == ""{
            FloatingMessage().floatingMessage(Message: "Please enter your Password", Color: .red, onPresentation: {
                self.passwordField.becomeFirstResponder()
            }) {}
            return
        }
        
        loginButton.showLoading()
        loginButton.activityIndicator.tintColor = .white
        Networking.sharedInstance.loginUser(Email: email, Password: password, dataCompletion: { (user) in
            self.loginButton.hideLoading()
            UserDefaults.standard.setIsLoggedIn(value: true)
            Caching.sharedInstance.saveUserDetailsToCache(user: user)
            
            FloatingMessage().longFloatingMessage(Message: "Successfully logged in!", Color: UIColor.CustomColors.Green.register, onPresentation: {
                Networking.sharedInstance.getRegisteredEvents(dataCompletion: { (data) in
                    var subscribeDictionary = [String: Bool]()
                   if let subsDict = UserDefaults.standard.dictionary(forKey: "subsDictionary") as? [String: Bool]{
                       subscribeDictionary = subsDict
                   }
                    for event in data{
                        subscribeDictionary["event-\(event.event)"] = true
                        print(event.event)
                        Messaging.messaging().subscribe(toTopic: "event-\(event.event)") { (err) in
                        if let err = err{
                            print(err)
                            print("Error in Subscribe - \(event.event)")
                        }else{
                            print("Subscribe Successful - \(event.event)")
                        }
                            
                        }
                    }
                    
                    Messaging.messaging().subscribe(toTopic: "user-\(user.id)") { (err) in
                        if let err = err{
                            print(err)
                            print("Error in Subscribe - User with ID: \(user.id)")
                        }else{
                            print("Subscribe Successful - User with ID: \(user.id)")
                        }
                    }
                    
                    subscribeDictionary["user-\(user.id)"] = true
                    UserDefaults.standard.set(subscribeDictionary, forKey: "subsDictionary")
                    UserDefaults.standard.synchronize()
                    
                }) { (message) in
                    print(message)
                }
                self.dismiss(animated: true)
            }) {
            }
        }) { (errorMessage) in
            self.loginButton.hideLoading()
            if errorMessage == "Invalid email/password combination"{
                FloatingMessage().floatingMessage(Message: "Invalid Credentials", Color: .red, onPresentation: {
                    self.emailField.becomeFirstResponder()
                }) {}
            }else{
                FloatingMessage().floatingMessage(Message: errorMessage, Color: .red, onPresentation: {
                    self.emailField.becomeFirstResponder()
                }) {}
            }
            print(errorMessage)
            return
        }
    }
    
    @objc func handleDismiss(){
        self.dismiss(animated: true)
    }
    
    @objc func handleForgotPassword(){
        guard let email = emailField.text else { return }
        
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
        
        forgotPasswordButton.showLoading()
        forgotPasswordButton.activityIndicator.color = UIColor.CustomColors.Blue.logoLightGreen
        
        Networking.sharedInstance.forgotPasswordFor(Email: email, dataCompletion: { (successMessage) in
            self.forgotPasswordButton.hideLoading()
            FloatingMessage().longFloatingMessage(Message: "A Reset Password link has been sent to \(email).", Color: UIColor.CustomColors.Blue.register, onPresentation: {
                self.hideKeyboard()
            }) {}
            print(successMessage)
        }) { (errorMessage) in
            self.forgotPasswordButton.hideLoading()
            FloatingMessage().floatingMessage(Message: errorMessage, Color: .red, onPresentation: {
                self.emailField.becomeFirstResponder()
            }) {}
            print(errorMessage)
            return
        }
    }

    @objc func handleRegister(){
        let signUpVC = SignUpViewController()
        signUpVC.loginViewController = self
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    func validateEmail(enteredEmail: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: enteredEmail)
    }
}
