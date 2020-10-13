//
//  EventViewController.swift
//  TechTetva-19
//
//  Created by Naman Jain on 01/09/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit
import Disk
import AudioToolbox
import FirebaseMessaging

class EventsViewController: UITableViewController {
    
    var scheduleController: ScheduleController?
    var tagsEventController: TagsEventsViewController?
    var featuredEventController: FeaturedEventsConroller?
    
    var event: Event! {
        didSet{
            tableView.reloadData()
        }
    }
    
    var schedule: Schedule? {
        didSet{
            tableView.reloadData()
        }
    }
    
    var categoriesDictionary = [Int: Category]()
    var delegateDictionary = [Int: DelegateCard]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = UIColor.CustomColors.Black.background
//        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        tableView.register(EventCell.self, forCellReuseIdentifier: "cellId")
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        getCachedCategoriesDictionary()
        getCachedDelegatedCardDictionary()
    }

    func getCachedCategoriesDictionary(){
        do{
            let retrievedCategoriesDictionary = try Disk.retrieve(categoriesDictionaryCache, from: .caches, as: [Int: Category].self)
            self.categoriesDictionary = retrievedCategoriesDictionary
        }
        catch let error{
            print(error)
        }
    }
    
    func getCachedDelegatedCardDictionary(){
        do{
            let retDict = try Disk.retrieve(delegateCardsDictionaryCache, from: .caches, as: [Int: DelegateCard].self)
            self.delegateDictionary = retDict
        }
        catch let error{
            print(error)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let _ = self.schedule else{ return 5 }
        return 9
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! EventCell
        
        var textLabel = "N/A"
        var detailedTextLabel = "N/A"
        var imageName = "calendar"
        let formatter = DateFormatter()
        guard let event = event else { return cell }
        let category = categoriesDictionary[event.category]
        
        cell.selectionStyle = .none
        switch indexPath.row {
        case 0:
            if let schedule = self.schedule{
                textLabel = "Round"
                detailedTextLabel = "\(schedule.round)"
                imageName = "assessment"
            }else{
                textLabel = "Category"
                detailedTextLabel = category?.name ?? ""
                imageName = "category"
            }
            break
        case 1:
            if let _ = self.schedule{
                textLabel = "Category"
                detailedTextLabel = category?.name ?? ""
                imageName = "category"
                break
            }else{
                textLabel = "Team Size"
                detailedTextLabel = event.minTeamSize == event.maxTeamSize ? "\(event.minTeamSize)" : "\(event.minTeamSize) - \(event.maxTeamSize)"
                imageName = "group"
            }

        case 2:
            if let schedule = self.schedule{
                textLabel = "Date"
                formatter.dateFormat = "dd MMM yyyy"
                let startDate = Date(dateString: schedule.start)
                detailedTextLabel = formatter.string(from: startDate)
            }else{
                textLabel = "Delegate Card"
                if let card = self.delegateDictionary[event.delCardType]{
                    detailedTextLabel = "\(card.name)"
                }else{
                   detailedTextLabel = "\(event.delCardType)"
                }
                
                imageName = "card"
                if detailedTextLabel != "" {
                    cell.selectionStyle = .gray
                }
            }
            break
        case 3:
            if let schedule = self.schedule{
                textLabel = "Time"
                formatter.dateFormat = "h:mm a"
                var startDate = Date(dateString: schedule.start)
                startDate = Calendar.current.date(byAdding: .hour, value: -5, to: startDate)!
                startDate = Calendar.current.date(byAdding: .minute, value: -30, to: startDate)!
                var endDate = Date(dateString: schedule.end)
                endDate = Calendar.current.date(byAdding: .hour, value: -5, to: endDate)!
                endDate = Calendar.current.date(byAdding: .minute, value: -30, to: endDate)!
                var dateString = formatter.string(from: startDate)
                dateString.append(" - \(formatter.string(from: endDate))")
                detailedTextLabel = dateString
                imageName = "timer"
            }else{
                textLabel = "Contact 1"
                detailedTextLabel = category?.cc1Name ?? "N/A"
                if detailedTextLabel != "N/A" {
                    cell.selectionStyle = .gray
                }
                imageName = "contact"
            }
            break
        case 4:
            if let schedule = self.schedule{
                textLabel = "Venue"
                detailedTextLabel = schedule.location
                imageName = "location"
            }else{
                textLabel = "Contact 2"
                detailedTextLabel = category?.cc2Name ?? "N/A"
                if detailedTextLabel != "N/A" {
                    cell.selectionStyle = .gray
                }
                imageName = "contact"
            }
            break
        case 5:
            if let _ = self.schedule{
                textLabel = "Team Size"
                detailedTextLabel = event.minTeamSize == event.maxTeamSize ? "\(event.minTeamSize)" : "\(event.minTeamSize) - \(event.maxTeamSize)"
                imageName = "group"
            }else{
                textLabel = "Contact 2"
                detailedTextLabel = category?.cc2Name ?? "N/A"
                if detailedTextLabel != "N/A" {
                    cell.selectionStyle = .gray
                }
                imageName = "contact"
            }
            break
        case 6:
            textLabel = "Delegate Card"
            if let card = self.delegateDictionary[event.delCardType]{
                detailedTextLabel = "\(card.name)"
            }else{
               detailedTextLabel = "\(event.delCardType)"
            }
            
            imageName = "card"
            if detailedTextLabel != "" {
                cell.selectionStyle = .gray
                cell.accessoryType = .disclosureIndicator
            }
            break
        case 7:
            textLabel = "Contact 1"
            detailedTextLabel = category?.cc1Name ?? "N/A"
            if detailedTextLabel != "N/A" {
                cell.selectionStyle = .gray
            }
            imageName = "contact"
            break
        case 8:
            textLabel = "Contact 2"
            detailedTextLabel = category?.cc2Name ?? "N/A"
            if detailedTextLabel != "N/A" {
                cell.selectionStyle = .gray
            }
            imageName = "contact"
            break
        default:
            textLabel = "Team Size"
            cell.selectionStyle = .gray
        }
        cell.imageView?.image = UIImage(named: imageName)
        cell.imageView?.setImageColor(color: .white)
        cell.textLabel?.text = textLabel
        cell.detailTextLabel?.text = detailedTextLabel
        return cell
    }
    
    let button = LoadingButton(type: .system) 
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.CustomColors.Black.background
        
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.text = event?.name ?? ""
        
        let closedReg = UILabel()
        closedReg.textColor = .red
        closedReg.font = UIFont.systemFont(ofSize: 13)
        closedReg.textAlignment = .center
        closedReg.numberOfLines = 2
        closedReg.text = "Registrations are closed for this event"
        
        button.backgroundColor = UIColor.CustomColors.Blue.register
        button.setTitle("Register Now", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.startAnimatingPressActions()
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: UIControl.State())
        if isSmalliPhone(){
            label.font = UIFont.boldSystemFont(ofSize: 15)
            closedReg.font = UIFont.systemFont(ofSize: 12)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        }else{
            label.font = UIFont.boldSystemFont(ofSize: 18)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        }
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(registerUserForEvent), for: .touchUpInside)

        
        if event.can_register == 1{
            view.addSubview(label)
            _ = label.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 12, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 25)
            
            view.addSubview(button)
            button.anchorWithConstants(top: label.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 8, leftConstant: 16, bottomConstant: 8, rightConstant: 16)
        }else{
            
            view.addSubview(label)
            _ = label.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 12, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 25)
            
            view.addSubview(closedReg)
            closedReg.anchorWithConstants(top: label.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 8, leftConstant: 16, bottomConstant: 8, rightConstant: 16)
        }
        
        return view
    }
    
    @objc func registerUserForEvent(){
        
        if UserDefaults.standard.isLoggedIn(){
            print("loggined")
            print(event.id)
            button.showLoading()
            button.activityIndicator.color = .white
            Networking.sharedInstance.registerEventWith(ID: event.id, successCompletion: { (message) in
                self.button.hideLoading()
                print(message)
                FloatingMessage().longFloatingMessage(Message: "Successfully Registered for \(self.event.name).", Color: UIColor.CustomColors.Blue.register, onPresentation: {   
                    Messaging.messaging().subscribe(toTopic: "event-\(self.event.id)") { (err) in
                        if let err = err{
                            print(err)
                            return
                        }
                        
                        var subscribeDictionary = [String: Bool]()
                        if let subsDict = UserDefaults.standard.dictionary(forKey: "subsDictionary") as? [String: Bool]{
                            subscribeDictionary = subsDict
                        }
                        subscribeDictionary["event-\(self.event.id)"] = true
                        UserDefaults.standard.set(subscribeDictionary, forKey: "subsDictionary")
                        UserDefaults.standard.synchronize()
                        print("Subscribe Succesful")
                    }
                }) {}
            }) { (message) in
                self.button.hideLoading()
                print(message)
                if message == "User already registered for event" {
                    FloatingMessage().longFloatingMessage(Message: "You have already registered for \(self.event.name)", Color: .orange, onPresentation: {}) {}
                }else if message == "Card for event not bought"{
                    FloatingMessage().longFloatingMessage(Message: "You have not bought the required delegate card.", Color: .orange, onPresentation: {
                        if let card = self.delegateDictionary[self.event.delCardType]{
                            DispatchQueue.main.async(execute: {
                                let alertController = UIAlertController(title: "\(card.name) Card", message: "\n\(card.description)\n\nMAHE PRICE : ₹\(card.MAHE_price)\nNON MAHE PRICE : ₹\(card.non_price)\n", preferredStyle: UIAlertController.Style.alert)
                                let purchaseOption = UIAlertAction(title: "Purchase", style: .default) { (_) in
                                    self.buyDelegateCard(delegateCardID: card.id)
                                }
                                let okayAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: { (_) in
                                })
                                alertController.addAction(okayAction)
                                alertController.addAction(purchaseOption)
                                self.present(alertController, animated: true, completion: nil)
                            })
                            return
                        }
                    }) {}
                }else{
                    FloatingMessage().longFloatingMessage(Message: message, Color: .orange, onPresentation: {}) {}
                }
            }
        }
        else{
            DispatchQueue.main.async(execute: {
                let alertController = UIAlertController(title: "Sign in to Register", message: "You need to be signed in to register for any event.", preferredStyle: UIAlertController.Style.actionSheet)
                let logInAction = UIAlertAction(title: "Sign In", style: .default, handler: { (action) in
                    let login = LoginViewController()
                    let loginNav = MasterNavigationBarController(rootViewController: login)
                    if #available(iOS 13.0, *) {
                        loginNav.modalPresentationStyle = .fullScreen
                        loginNav.isModalInPresentation = true
                    } else {
                        // Fallback on earlier versions
                    }
                    fromLogin = true
                    self.present(loginNav, animated: true)
                })
                let createNewAccountAction = UIAlertAction(title: "Create New Account", style: .default, handler: { (action) in
                    let login = LoginViewController()
                    let loginNav = MasterNavigationBarController(rootViewController: login)
                    fromLogin = true
                    self.present(loginNav, animated: true, completion: {
                        login.handleRegister()
                    })
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(logInAction)
                alertController.addAction(createNewAccountAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            })
            return
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 95
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension //60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row{
        case 6:
            if let card = self.delegateDictionary[self.event.delCardType]{
                DispatchQueue.main.async(execute: {
                    let alertController = UIAlertController(title: "\(card.name) Card", message: "\n\(card.description)\n\nMAHE PRICE : ₹\(card.MAHE_price)\nNON MAHE PRICE : ₹\(card.non_price)\n", preferredStyle: UIAlertController.Style.alert)
                    let purchaseOption = UIAlertAction(title: "Purchase", style: .default) { (_) in
                        self.buyDelegateCard(delegateCardID: card.id)
                    }
                    let okayAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: { (_) in
                    })
                    alertController.addAction(okayAction)
                    alertController.addAction(purchaseOption)
                    self.present(alertController, animated: true, completion: nil)
                })
                return
            }
        case 7:
            let category = categoriesDictionary[event.category]
            if let number = category?.cc1Contact{
                self.callNumber(number: number)
            }
        case 8:
            let category = categoriesDictionary[event.category]
            if let number = category?.cc2Contact{
                self.callNumber(number: number)
            }
        default: return
        }
    }
    
    fileprivate func callNumber(number: String){
        AudioServicesPlaySystemSound(1519)
        if let url = URL(string: "tel://\(number)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func buyDelegateCard(delegateCardID: Int){
        if UserDefaults.standard.isLoggedIn(){
            let popUp = SpinnerCardPopUp()
             UIApplication.shared.keyWindow?.addSubview(popUp)
             DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                 popUp.animateOut()
             }
             self.dismiss(animated: true) {
                 self.scheduleController?.performPaymentFor(delegateCardID: delegateCardID)
                self.tagsEventController?.performPaymentFor(delegateCardID: delegateCardID)
//                self.featuredEventsController?.performPaymentFor(delegateCardID: delegateCardID)
             }
        }else{
            DispatchQueue.main.async(execute: {
                let alertController = UIAlertController(title: "Sign in to Buy Delegate Cards", message: "You need to be signed in to buy a Delegate Card.", preferredStyle: UIAlertController.Style.actionSheet)
                let logInAction = UIAlertAction(title: "Sign In", style: .default, handler: { (action) in
                    let login = LoginViewController()
                    let loginNav = MasterNavigationBarController(rootViewController: login)
                    if #available(iOS 13.0, *) {
                        loginNav.modalPresentationStyle = .fullScreen
                        loginNav.isModalInPresentation = true
                    } else {
                        // Fallback on earlier versions
                    }
                    fromLogin = true
                    self.present(loginNav, animated: true)
                })
                let createNewAccountAction = UIAlertAction(title: "Create New Account", style: .default, handler: { (action) in
                    let login = LoginViewController()
                    let loginNav = MasterNavigationBarController(rootViewController: login)
                    fromLogin = true
                    self.present(loginNav, animated: true, completion: {
                        login.handleRegister()
                    })
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(logInAction)
                alertController.addAction(createNewAccountAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            })
            return
        }
    }
        
}


class EventCell: UITableViewCell{

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        
        if UIViewController().isSmalliPhone(){
            textLabel?.font = UIFont.systemFont(ofSize: 14)
            detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        }
        backgroundColor = .clear
        textLabel?.textColor = .white
        detailTextLabel?.numberOfLines = 0
        textLabel?.numberOfLines = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
