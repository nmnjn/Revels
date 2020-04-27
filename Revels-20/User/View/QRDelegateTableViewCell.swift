//
//  QRDelegateTableViewCell.swift
//  TechTetva-19
//
//  Created by Naman Jain on 28/09/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit
import SDWebImage

class QRDelegateIDTableViewCell: UITableViewCell {
    
    var usersViewController: UsersViewController?

    var user: User?{
        didSet{
            guard let user = user else { return }
                DispatchQueue.main.async {
//                    self.qrImageView.image = self.generateQRCode(from: user.qr)
                    print(user.qr)
                    let myString = user.qr
                    let data = myString.data(using: String.Encoding.ascii)
                    guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return }
                    qrFilter.setValue(data, forKey: "inputMessage")
                    guard let qrImage = qrFilter.outputImage else { return }
                    
                    let transform = CGAffineTransform(scaleX: 10, y: 10)
                    let scaledQrImage = qrImage.transformed(by: transform)
                    let processedImage = UIImage(ciImage: scaledQrImage)
                    self.qrImageView.image = processedImage
                }
//            let url = NSURL(string: "https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=\(user.qr)")
//            qrImageView.sd_setImage(with: url! as URL, placeholderImage:nil)

            
            nameLabel.text = user.name
            emailLabel.text = user.email
            collegeLabel.text = user.collname
            phoneLabel.text = user.mobile
            delegateIDLabel.text = "\(user.id)"
        }
    }
    
    lazy var spinnerView : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    let qrCodeView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 14
        view.layer.shadowColor = UIColor.white.cgColor
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 12
        view.layer.masksToBounds = false
        view.backgroundColor = .white
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.text = "Error 404"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    lazy var collegeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "There was an error"
        label.textColor = .lightGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var phoneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "fetching your details."
        label.textColor = .lightGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "please log out and login again!"
        label.textColor = .lightGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var delegateTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "Delegate ID"
        label.textColor = UIColor.init(white: 1, alpha: 0.25)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var delegateIDLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 45)
        label.text = "NA"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    lazy var qrImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var eventsButton: LoadingButton = {
        let button = LoadingButton(type: .system)
        button.startAnimatingPressActions()
        button.backgroundColor = UIColor.CustomColors.Blue.register
        button.setTitle("Registered Events", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(showRegisteredEvents), for: .touchUpInside)
        return button
    }()
    
    lazy var delegateCardButton: LoadingButton = {
        let button = LoadingButton(type: .system)
        button.startAnimatingPressActions()
        button.backgroundColor = UIColor.CustomColors.Green.register
        button.setTitle("Delegate Cards", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(showDelegateCards), for: .touchUpInside)
        return button
    }()
    
    
    @objc func showRegisteredEvents(){
        eventsButton.showLoading()
        eventsButton.activityIndicator.tintColor = .white
        eventsButton.isEnabled = false
        eventsButton.animateDown(sender: self.eventsButton)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.eventsButton.animateUp(sender: self.eventsButton)
        }
        Networking.sharedInstance.getRegisteredEvents(dataCompletion: { (data) in
            self.eventsButton.hideLoading()
            self.eventsButton.isEnabled = true
            print(data)
            if data.count == 0{
                FloatingMessage().longFloatingMessage(Message: "You have not registered for any events.", Color: .orange, onPresentation: {}) {}
                return
            }else{
               self.usersViewController?.showRegisteredEvents(RegisteredEvents: data)
            }
            
        }) { (message) in
            print(message)
            self.eventsButton.hideLoading()
            self.eventsButton.isEnabled = true
        }
    }
    
    @objc func showDelegateCards(){
        delegateCardButton.showLoading()
        delegateCardButton.activityIndicator.tintColor = .white
        delegateCardButton.isEnabled = false
        delegateCardButton.animateDown(sender: self.delegateCardButton)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.delegateCardButton.animateUp(sender: self.delegateCardButton)
        }
        let apiStruct = ApiStruct(url: boughtDelegateCardsURL, method: .get, body: nil)
        WSManager.shared.getJSONResponse(apiStruct: apiStruct, success: { (boughtCards: BoughtDelegateCard) in
           self.delegateCardButton.hideLoading()
           self.delegateCardButton.isEnabled = true
            var cards = [Int]()
            for card in boughtCards.data{
                cards.append(card.card_type)
            }
            self.usersViewController?.showDelegateCards(BoughtCards: cards)
        }) { (error) in
           print(error)
            self.delegateCardButton.hideLoading()
            self.delegateCardButton.isEnabled = true
        }
    }
    
    lazy var logoutButton: LoadingButton = {
        let button = LoadingButton(type: .system)
        button.setTitle("LOG OUT", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.red, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }()
    
    @objc func handleLogout(){
        logoutButton.animateDown(sender: self.logoutButton)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.logoutButton.animateUp(sender: self.logoutButton)
        }
        
        usersViewController?.logOutUser()
    }
    
    lazy var loveLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 12)        
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        if UIViewController().isSmalliPhone(){
            addSubview(qrCodeView)
            _ = qrCodeView.anchor(top: safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 150, heightConstant: 150)
            qrCodeView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            qrCodeView.addSubview(spinnerView)
            spinnerView.fillSuperview()
            spinnerView.startAnimating()
            qrCodeView.addSubview(qrImageView)
            qrImageView.fillSuperview(padding: UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24))
            
            nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
            addSubview(nameLabel)
            _ = nameLabel.anchor(top: qrCodeView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 20, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 0)
            
            collegeLabel.font = UIFont.boldSystemFont(ofSize: 15)
            addSubview(collegeLabel)
            _ = collegeLabel.anchor(top: nameLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 12, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
            phoneLabel.font = UIFont.boldSystemFont(ofSize: 15)
            addSubview(phoneLabel)
            _ = phoneLabel.anchor(top: collegeLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
            emailLabel.font = UIFont.boldSystemFont(ofSize: 15)
            addSubview(emailLabel)
            _ = emailLabel.anchor(top: phoneLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
            delegateTitleLabel.font = UIFont.boldSystemFont(ofSize: 13)
            addSubview(delegateTitleLabel)
            _ = delegateTitleLabel.anchor(top: emailLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 20, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
            delegateIDLabel.font = UIFont.boldSystemFont(ofSize: 25)
            addSubview(delegateIDLabel)
            _ = delegateIDLabel.anchor(top: delegateTitleLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
            
            addSubview(eventsButton)
            _ = eventsButton.anchor(top: delegateIDLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 20, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 40)
            
            addSubview(delegateCardButton)
            _ = delegateCardButton.anchor(top: eventsButton.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 40)
            
            addSubview(logoutButton)
            _ = logoutButton.anchor(top: delegateCardButton.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 32, rightConstant: 16, widthConstant: 0, heightConstant: 40)
            
            eventsButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
            delegateCardButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
            logoutButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
            
        }else{
            addSubview(qrCodeView)
            _ = qrCodeView.anchor(top: safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 24, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 200, heightConstant: 200)
            qrCodeView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            qrCodeView.addSubview(spinnerView)
            spinnerView.fillSuperview()
            spinnerView.startAnimating()
            qrCodeView.addSubview(qrImageView)
            qrImageView.fillSuperview(padding: UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24))
            
            addSubview(nameLabel)
            _ = nameLabel.anchor(top: qrCodeView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 32, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 0)
            
            addSubview(collegeLabel)
            _ = collegeLabel.anchor(top: nameLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
            
            addSubview(phoneLabel)
            _ = phoneLabel.anchor(top: collegeLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
            
            addSubview(emailLabel)
            _ = emailLabel.anchor(top: phoneLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
            
            addSubview(delegateTitleLabel)
            _ = delegateTitleLabel.anchor(top: emailLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 32, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
            
            addSubview(delegateIDLabel)
            _ = delegateIDLabel.anchor(top: delegateTitleLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
            
            addSubview(eventsButton)
            _ = eventsButton.anchor(top: delegateIDLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 24, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 50)
            
            addSubview(delegateCardButton)
            _ = delegateCardButton.anchor(top: eventsButton.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 14, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 50)
            
            addSubview(logoutButton)
            _ = logoutButton.anchor(top: delegateCardButton.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 8, leftConstant: 16, bottomConstant: 32, rightConstant: 16, widthConstant: 0, heightConstant: 50)
        }
        
        addSubview(loveLabel)
        _ = loveLabel.anchor(top: nil, left: leftAnchor, bottom: topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 50, rightConstant: 16, widthConstant: 0, heightConstant: 30)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

