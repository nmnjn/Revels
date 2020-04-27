//
//  FeaturedEventsConroller.swift
//  Revels-20
//
//  Created by Naman Jain on 23/02/20.
//  Copyright © 2020 Naman Jain. All rights reserved.
//

import UIKit
import AudioToolbox

class FeaturedEventsConroller: UITableViewController {
    
    var eventsDictionary = [Int: Event]()
    
    let names = ["MIT Debating Tournament", "The Fashion Show", "Battle of Bands", "Nukkad Natak", "Curtain Call", "Groove", "Desi Tadka", "Mr. and Mrs. Revels"]
    let prize = ["75000", "40000", "37000", "33000", "30000", "26000", "22000", "12000"]
    let ids = [76,75,60,66,65,9,10,52]
    
    fileprivate let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getEventsData()
    }
    
    
    func getEventsData(){
        Caching.sharedInstance.getCachedData(dataType: [Int: Event](), cacheLocation: eventsDictionaryCache, dataCompletion: { (data) in
            self.eventsDictionary = data
        }) { (error) in
            print(error)
            //fetch events here and cache them
        }
    }
    
    // MARK: - Setup Functions
    
    fileprivate func setupTableView(){
        navigationItem.title = "Featured Events"
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.CustomColors.Black.background
        tableView.register(FeaturedEventsCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        tableView.allowsSelection = true
    }
    
    // MARK: - TableView Functions
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! FeaturedEventsCell
        cell.moneyLabel.text = "₹\(prize[indexPath.row])"
        cell.moneyBackgroundLabel.text = prize[indexPath.row]
        cell.eventName.text = names[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = self.ids[indexPath.row]
        if let event = self.eventsDictionary[id]{
            self.handleEventTap(withEvent: event)
        }
    }
    
    let slideInTransitioningDelegate = SlideInPresentationManager(from: UIViewController(), to: UIViewController())
    
    func handleEventTap(withEvent event: Event){
        AudioServicesPlaySystemSound(1519)
        let eventViewController = EventsViewController()
        slideInTransitioningDelegate.categoryName = "\(event.shortDesc)"
        eventViewController.modalPresentationStyle = .custom
        eventViewController.transitioningDelegate = slideInTransitioningDelegate
        eventViewController.event = event
        eventViewController.schedule = nil
//        eventViewController.tagsEventController = self
        present(eventViewController, animated: true, completion: nil)
        print(event.id)
        print(event.name)
    }
    
    func performPaymentFor(delegateCardID: Int){
        let vc = PaymentsWebViewController()
        vc.delegateCardID = delegateCardID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private var themedStatusBarStyle: UIStatusBarStyle?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return themedStatusBarStyle ?? UIStatusBarStyle.lightContent
    }
    
    func updateStatusBar(){
        themedStatusBarStyle = .lightContent
        setNeedsStatusBarAppearanceUpdate()
    }
}


class FeaturedEventsCell: UITableViewCell {
    
    // MARK: - Properties
    
    lazy var backgroundCardView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.CustomColors.Black.card
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var moneyBackgroundLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 85, weight: .bold)
        label.textColor = .init(white: 1, alpha: 0.05)
        label.textAlignment = .right
        return label
    }()
    
    lazy var eventName: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.numberOfLines = 2
        label.textColor = .white
        return label
    }()
    
    lazy var uptoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 11, weight: .light)
        label.text = "Cash Prizes Worth"
        label.numberOfLines = 1
        label.textColor = .white
        return label
    }()
    
    lazy var moneyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 29, weight: .bold)
        label.textColor = UIColor.CustomColors.Skin.accent
        return label
    }()
    
    let circleView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.CustomColors.Skin.accent.withAlphaComponent(0.1)
        return view
    }()
    
    let circleView2: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.CustomColors.Skin.accent.withAlphaComponent(0.4)
        return view
    }()
    
    lazy var infoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "info")
        imageView.setImageColor(color: .white)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Functions
    
    fileprivate func setupViews(){
        
        var infoHeight: CGFloat = 25
        
        if UIViewController().isSmalliPhone(){
            moneyBackgroundLabel.font = UIFont.systemFont(ofSize: 70, weight: .bold)
            eventName.font = UIFont.systemFont(ofSize: 23, weight: .bold)
            infoHeight = 18
        }
        
        addSubview(backgroundCardView)
        backgroundCardView.addSubview(circleView)
        backgroundCardView.addSubview(circleView2)
        backgroundColor = UIColor.CustomColors.Black.background
//        backgroundCardView.anchorWithConstants(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 8, leftConstant: 16, bottomConstant: 8, rightConstant: 16)
//        backgroundCardView.clipsToBounds = true
        
        addSubview(eventName)
        eventName.anchorWithConstants(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 24, leftConstant: 32, bottomConstant: 0, rightConstant: 32)
        
        backgroundCardView.addSubview(moneyBackgroundLabel)
        
        addSubview(moneyLabel)
        moneyLabel.anchorWithConstants(top: eventName.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 65, leftConstant: 32, bottomConstant: 16, rightConstant: 32)
        
        addSubview(uptoLabel)
        uptoLabel.anchorWithConstants(top: nil, left: leftAnchor, bottom: moneyLabel.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 32, bottomConstant: 0, rightConstant: 38)
        
        backgroundCardView.anchorWithConstants(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 8, leftConstant: 16, bottomConstant: 8, rightConstant: 16)
        backgroundCardView.clipsToBounds = true
        
        _ = moneyBackgroundLabel.anchor(top: nil, left: backgroundCardView.leftAnchor, bottom: backgroundCardView.bottomAnchor, right: backgroundCardView.rightAnchor, topConstant: 16, leftConstant: -8, bottomConstant: -28, rightConstant: -16, widthConstant: 0, heightConstant: 0)
        
        backgroundCardView.addSubview(infoImageView)
        
        _ = infoImageView.anchor(top: nil, left: backgroundCardView.leftAnchor, bottom: backgroundCardView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 16, bottomConstant: 16, rightConstant: 16, widthConstant: infoHeight, heightConstant: infoHeight)
        
        
        
        circleView.leadingAnchor.constraint(equalTo: backgroundCardView.leadingAnchor, constant: -100).isActive = true
        circleView.topAnchor.constraint(equalTo: backgroundCardView.topAnchor, constant: -100).isActive = true
        circleView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        circleView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        circleView.layer.cornerRadius = 116
        
        circleView2.leadingAnchor.constraint(equalTo: backgroundCardView.leadingAnchor, constant: -116).isActive = true
        circleView2.topAnchor.constraint(equalTo: backgroundCardView.topAnchor, constant: -116).isActive = true
        circleView2.heightAnchor.constraint(equalToConstant: 200).isActive = true
        circleView2.widthAnchor.constraint(equalToConstant: 200).isActive = true
        circleView2.layer.cornerRadius = 100
        
    }
    
}
