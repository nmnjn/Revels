//
//  UsersViewController.swift
//  TechTetva-19
//
//  Created by Naman Jain on 24/09/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit
import FirebaseMessaging

//this boolean is used for reloading user page when loading for the first time
var fromLogin = true


class UsersViewController: UITableViewController {
    
    var user: User? {
        didSet{
            tableView.isScrollEnabled = true
            tableView.reloadData()
            tableView.showsVerticalScrollIndicator = false
            infoView?.alpha = 0
            makeClearNavBar()
        }
    }
    
    private var themedStatusBarStyle: UIStatusBarStyle?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return themedStatusBarStyle ?? UIStatusBarStyle.lightContent
    }
    
    func updateStatusBar(){
        themedStatusBarStyle = .lightContent
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func makeClearNavBar(){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        updateStatusBar()
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.view.backgroundColor = .clear
    }
    
    var infoView: InformationView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.CustomColors.Black.background
        tableView.register(QRDelegateIDTableViewCell.self, forCellReuseIdentifier: "cellId")
        if UserDefaults.standard.isLoggedIn(){
            
        }else{
            setupViewForLoggedOutUser()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.isLoggedIn() {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.updateStatusBar()
            if fromLogin {
                if let user = Caching.sharedInstance.getUserDetailsFromCache() {
                    print(user)
                    self.user = user
                }else{
                    self.logOutUser()
                    print("cannot get user")
                }
                fromLogin = false
            }
        }else{
            print("not logged in")
        }
    }
    
    func setupViewForLoggedOutUser(){
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        tableView.reloadData()
        tableView.isScrollEnabled = false
        infoView = InformationView(frame: self.view.frame)
        infoView?.usersViewController = self
        view.addSubview(infoView!)
        updateStatusBar()
    }
    
    func presentLogin(){
        let login = LoginViewController()
        let loginNav = MasterNavigationBarController(rootViewController: login)
        if #available(iOS 13.0, *) {
            loginNav.modalPresentationStyle = .fullScreen
            loginNav.isModalInPresentation = true
        } else {
            // Fallback on earlier versions
        }
        fromLogin = true
        present(loginNav, animated: true)
    }
    
    func logOutUser(){
        let actionSheet = UIAlertController(title: "Are you Sure?", message: nil, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let sureAction = UIAlertAction(title: "Yes", style: .destructive) { (_) in
            if let subsDict = UserDefaults.standard.dictionary(forKey: "subsDictionary") as? [String: Bool]{
                for (key, _) in subsDict{
                    Messaging.messaging().unsubscribe(fromTopic: key)
                    print("Unsubscribing from \(key)")
                }
            }
            UserDefaults.standard.set([:], forKey: "subsDictionary")
            UserDefaults.standard.set(false, forKey: "boughtProshow")
            UserDefaults.standard.synchronize()
            
            UserDefaults.standard.setIsLoggedIn(value: false)
            Networking.sharedInstance.logoutUser()
            self.setupViewForLoggedOutUser()
        }
        actionSheet.addAction(sureAction)
        actionSheet.addAction(cancel)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    func showRegisteredEvents(RegisteredEvents: [RegisteredEvent]){
        let vc = RegisteredEventsViewController()
        vc.registeredEvents = RegisteredEvents
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showDelegateCards(BoughtCards: [Int]){
        let vc = DelegateCardsController()
        vc.Cards = Caching.sharedInstance.getDelegateCardsFromCache()
        vc.boughtCards = BoughtCards
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if UserDefaults.standard.isLoggedIn(){
            return 1
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! QRDelegateIDTableViewCell
        cell.user = self.user
        cell.usersViewController = self
        cell.selectionStyle = .none
        return cell
    }
    
}
