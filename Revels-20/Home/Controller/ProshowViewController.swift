//
//  ProshowViewController.swift
//  Revels-20
//
//  Created by Naman Jain on 31/01/20.
//  Copyright © 2020 Naman Jain. All rights reserved.
//

//
//  ProshowViewController.swift
//  TechTetva-19
//
//  Created by Tushar Tapadia on 13/01/20.
//  Copyright © 2020 Naman Jain. All rights reserved.
//

import UIKit
import Disk
import SDWebImage

struct ProResponse: Codable{
    let success: Bool
    let data: [String: ProSchedule]
    let rules1: String?
    let rules2: String?
    let sales: Bool?
}

struct ProSchedule: Codable{
    let venue: String
    let time: String
    let artist_1: String?
    let artist_2: String?
    let artist_1_image_url: String?
    let artist_2_image_url: String?
    let artist_1_cutout: String?
    let artist_2_cutout: String?
    let description: String?
}



class ProshowViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, MenuControllerDelegate  {
    
    var proshowData: [String: ProSchedule]? {
        didSet{
            collectionView.reloadData()
        }
    }
    
    var rules1: String = ""
    var rules2: String = ""

    func didTapMenuItem(indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    fileprivate let menuController = MenuController(collectionViewLayout: UICollectionViewFlowLayout())
    fileprivate let cellId = "cellId"
    fileprivate let cellId2 = "cellId2"
    fileprivate let cellId3 = "cellId3"
    fileprivate let cellId4 = "cellId4"
    fileprivate let menuCellId = "menuCellId"
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let offset = x / CGFloat(menuController.menuItems.count)
        menuController.menuBar.transform = CGAffineTransform(translationX: offset, y: 0)
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        let item = x / view.frame.width
        let indexPath = IndexPath(item: Int(item), section: 0)
        menuController.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        menuController.menuItems = ["Day 1", "Day 2", "Day 3", "Day 4"] 
        menuController.delegate = self
        menuController.markerBar.backgroundColor = UIColor.CustomColors.Blue.accent
        menuController.specialColor = UIColor.CustomColors.Blue.accent
        menuController.menuBar.backgroundColor = UIColor.CustomColors.Black.background
        menuController.collectionView.backgroundColor = UIColor.CustomColors.Black.background
        menuController.shadowBar.backgroundColor = UIColor.CustomColors.Black.background
        setupLayout()
        setupView()
        getProshowData()
    }
    let buyButton = UIButton(type: .system)
    
    func setupView(){
        
        buyButton.setTitle("BUY", for: .normal)
        buyButton.configure(color: .white, font: UIFont.boldSystemFont(ofSize: 16))
        buyButton.setTitleColor(.systemBlue, for: .normal)
        buyButton.addTarget(self, action: #selector(buyProshowPass), for: .touchUpInside)
        let rightItem = UIBarButtonItem(customView: buyButton)
        self.navigationItem.rightBarButtonItem = rightItem
        buyButton.contentEdgeInsets = .init(top: 4, left: 16, bottom: 4, right: 16)
        buyButton.layer.cornerRadius = 12
        buyButton.backgroundColor = .white
        navigationItem.title = "Ground Zero"
        buyButton.isHidden = true
    }

    func getProshowData(){
        if let data = Caching.sharedInstance.getProshowFromCache(){
            self.proshowData = data.data
            self.rules1 = data.rules1 ?? ""
            self.rules2 = data.rules2 ?? ""
            if data.sales == true && !UserDefaults.standard.bool(forKey: "boughtProshow"){
                buyButton.isHidden = false
            }
        }else{
            Networking.sharedInstance.getProshowData(dataCompletion: { (data) in
                self.proshowData = data.data
                self.rules1 = data.rules1 ?? ""
                self.rules2 = data.rules2 ?? ""
                if data.sales == true && !UserDefaults.standard.bool(forKey: "boughtProshow"){
                    self.buyButton.isHidden = false
                }
                Caching.sharedInstance.saveProshowToCache(proshow: data)
            }) { (errorMessage) in
                print(errorMessage)
            }
        }
    }
    
    fileprivate func setupLayout() {
        let menuView = menuController.view!
        menuView.backgroundColor = .white
        view.addSubview(menuView)
        _ = menuView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
        menuController.collectionView.selectItem(at: [0, 0], animated: true, scrollPosition: .centeredHorizontally)
        
        view.backgroundColor = .white
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
        }
        
        collectionView.backgroundColor = UIColor.CustomColors.Black.background
        collectionView.anchor(top: menuView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        collectionView.register(ProshowDay1Cell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(ProshowDay2Cell.self, forCellWithReuseIdentifier: cellId2)
        collectionView.register(ProshowDay3Cell.self, forCellWithReuseIdentifier: cellId3)
        collectionView.register(ProshowDay4Cell.self, forCellWithReuseIdentifier: cellId4)
        collectionView.isPagingEnabled = true
        collectionView.allowsSelection = true
        collectionView.showsHorizontalScrollIndicator = false
    }
    
        override func viewWillAppear(_ animated: Bool) {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            updateStatusBar()
        }

        private var themedStatusBarStyle: UIStatusBarStyle?

        override var preferredStatusBarStyle: UIStatusBarStyle{
            return themedStatusBarStyle ?? UIStatusBarStyle.lightContent
        }
        func updateStatusBar(){
            themedStatusBarStyle = .lightContent
            setNeedsStatusBarAppearanceUpdate()
        }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuController.menuItems.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ProshowDay1Cell
            cell.proshowData = self.proshowData
            cell.rules = self.rules1
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId2, for: indexPath) as! ProshowDay2Cell
            cell.proshowData = self.proshowData
            cell.rules = self.rules1
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId3, for: indexPath) as! ProshowDay3Cell
            cell.proshowData = self.proshowData
            cell.rules = self.rules2
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId4, for: indexPath) as! ProshowDay4Cell
            cell.proshowData = self.proshowData
            cell.rules = self.rules2
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId2, for: indexPath) as! ProshowDay2Cell
            cell.proshowData = self.proshowData
            return cell
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: view.frame.height - 50)
    }
    
    @objc func buyProshowPass(){
        DispatchQueue.main.async(execute: {
            let alertController = UIAlertController(title: "Proshow Pass", message: "\nA delegate pass that gives you access to our Ground Zero proshow concert for the last two nights of the fest.\n\nPlease read the given note carefully. \nFor Students not belonging to Manipal Institute of Technology the pass is only valid for Delegate Card Holder for Cultural/Sport Event. One must own a General, Flagship or any Sports delegate card to be able to buy proshow passes.\n\nAMOUNT TO PAY : ₹350", preferredStyle: UIAlertController.Style.alert)
            let purchaseOption = UIAlertAction(title: "Purchase", style: .default) { (_) in
                self.buyCard(id: 58)
            }
            let okayAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: { (_) in
                
            })
            alertController.addAction(okayAction)
            alertController.addAction(purchaseOption)
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    func markedCardAsBought(){
        self.buyButton.isHidden = true
        UserDefaults.standard.set(true, forKey: "boughtProshow")
        UserDefaults.standard.synchronize()
        
        DispatchQueue.main.async(execute: {
            let alertController = UIAlertController(title: "Purchase completed!", message: "You can now access the Proshow Pass through the Delegate Cards section on your profile (user) page.", preferredStyle: UIAlertController.Style.alert)
            let okayAction = UIAlertAction(title: "Okay", style: .destructive, handler: { (_) in
                
            })
            alertController.addAction(okayAction)
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    
    func buyCard(id: Int){
        if UserDefaults.standard.isLoggedIn(){
            let vc = PaymentsWebViewController()
            vc.delegateCardID = id
            vc.proshowViewController = self
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            DispatchQueue.main.async(execute: {
                let alertController = UIAlertController(title: "Sign in to Buy Proshow Pass", message: "You need to be signed in to buy the Proshow Pass.", preferredStyle: UIAlertController.Style.actionSheet)
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

class ProshowDay1Cell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    
    var rules: String = ""
    
    var proshowData: [String: ProSchedule]? {
        didSet{
            tableView.reloadData()
        }
    }
    
    fileprivate let cellId = "cellId"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Setup Functions
    
    fileprivate func setupTableView(){
        tableView.backgroundColor = UIColor.CustomColors.Black.background
        addSubview(tableView)
        tableView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        tableView.register(ProTableViewCellSingle.self, forCellReuseIdentifier: "cellIdSingle")
        tableView.backgroundColor = UIColor.CustomColors.Black.background
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 16, right: 0)
    }
    
    // MARK: - TableView Functions
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = proshowData{
            return 1
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let schedule = self.proshowData?["1"] else { return UITableViewCell()}
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdSingle", for: indexPath ) as! ProTableViewCellSingle
        cell.locationLabel.text = "\(schedule.venue )\n\(schedule.time )"
        let url1 = URL(string: schedule.artist_1_image_url ?? "")
        cell.artistImage1.sd_setImage(with: url1!, placeholderImage: nil)
        cell.selectionStyle = .none
        cell.descriptionLabel.text = schedule.description ?? ""
        cell.ruleLabel.text = self.rules
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

class ProshowDay2Cell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    // Render for Aditi Hundia
    
    // MARK: - Properties
    var rules: String = ""
    var proshowData: [String: ProSchedule]? {
        didSet{
            tableView.reloadData()
        }
    }
    
    fileprivate let cellId = "cellId"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Setup Functions
    
    fileprivate func setupTableView(){
        tableView.backgroundColor = UIColor.CustomColors.Black.background
        addSubview(tableView)
        tableView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        tableView.register(ProTableViewCellSingle.self, forCellReuseIdentifier: "cellIdSingle")
        tableView.backgroundColor = UIColor.CustomColors.Black.background
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 16, right: 0)
    }
    
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let schedule = self.proshowData?["2"] else { return UITableViewCell()}
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdSingle", for: indexPath ) as! ProTableViewCellSingle
            cell.locationLabel.text = "\(schedule.venue )\n\(schedule.time )"
            let url1 = URL(string: schedule.artist_1_image_url ?? "")
            cell.artistImage1.sd_setImage(with: url1!, placeholderImage: nil)
            cell.selectionStyle = .none
            cell.descriptionLabel.text = schedule.description ?? ""
            cell.ruleLabel.text = self.rules
            return cell
        }
    
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
}

class ProshowDay3Cell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    // Render for Yellow Diary and Zaeden
    
    // MARK: - Properties
    var rules: String = ""
    var proshowData: [String: ProSchedule]? {
        didSet{
            tableView.reloadData()
        }
    }
    
    fileprivate let cellId = "cellId"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Setup Functions
    
    fileprivate func setupTableView(){
        tableView.backgroundColor = UIColor.CustomColors.Black.background
        addSubview(tableView)
        tableView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
        tableView.register(ProTableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.backgroundColor = UIColor.CustomColors.Black.background
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 16, right: 0)
    }
    
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let schedule = self.proshowData?["3"] else { return UITableViewCell()}
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath ) as! ProTableViewCell
            let url1 = URL(string: schedule.artist_1_image_url ?? "")
            cell.artistImage1.sd_setImage(with: url1!, placeholderImage: nil)
            let url2 = URL(string: schedule.artist_2_image_url ?? "")
            cell.artistImage2.sd_setImage(with: url2!, placeholderImage: nil)
            
            cell.locationLabel.text = "\(schedule.venue )\n\(schedule.time )"
            cell.descriptionLabel.text = schedule.description ?? ""
            cell.ruleLabel.text = self.rules
            return cell
        }
    
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
}

class ProshowDay4Cell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    // Render for Prateek Kuhad
    
    // MARK: - Properties
    var rules: String = ""
    var proshowData: [String: ProSchedule]? {
        didSet{
            tableView.reloadData()
        }
    }
    
    fileprivate let cellId = "cellId"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Setup Functions
    
    fileprivate func setupTableView(){
        tableView.backgroundColor = UIColor.CustomColors.Black.background
        addSubview(tableView)
        tableView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
        tableView.register(ProTableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.backgroundColor = UIColor.CustomColors.Black.background
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 16, right: 0)
    }
    
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let schedule = self.proshowData?["4"] else { return UITableViewCell()}
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath ) as! ProTableViewCell
            let url1 = URL(string: schedule.artist_1_image_url ?? "")
            cell.artistImage1.sd_setImage(with: url1!, placeholderImage: nil)
            let url2 = URL(string: schedule.artist_2_image_url ?? "")
            cell.artistImage2.sd_setImage(with: url2!, placeholderImage: nil)
            
            cell.locationLabel.text = "\(schedule.venue )\n\(schedule.time )"
            cell.descriptionLabel.text = schedule.description ?? ""
            cell.ruleLabel.text = self.rules
            return cell
        }
    
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
}

 class ProTableViewCell: UITableViewCell{
     
     var height: CGFloat = 200
        
        lazy var backgroundCard: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.CustomColors.Black.card
            view.layer.cornerRadius = 10
            view.alpha = 0.2
            return view
        }()

    var artistImage1: UIImageView = {
        let artImage = UIImageView(image: UIImage(named: "IMG_0"))
        artImage.contentMode = .scaleAspectFill
        artImage.layer.masksToBounds = true
        artImage.layer.cornerRadius = 10
        return artImage
    }()

    var artistImage2: UIImageView = {
        let artImage = UIImageView(image: UIImage(named: "IMG_0"))
        artImage.contentMode = .scaleAspectFill
        artImage.layer.masksToBounds = true
        artImage.layer.cornerRadius = 10
        return artImage
    }()
    
    lazy var venueBackgroundText: UILabel = {
        let label = UILabel()
        label.text = "VENUE"
        label.font = UIFont.systemFont(ofSize: 100, weight: .bold)
        label.textColor = UIColor(white: 0.3, alpha: 0.1)
        label.textAlignment = .center
        return label
    }()
 
   lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
       label.textColor = UIColor(white: 1, alpha: 0.7)
       label.textAlignment = .left
       label.numberOfLines = 0
    
        return label
    }()
    
    lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "VENUE"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.textColor = UIColor(white: 1, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    lazy var rulesTextLabel: UILabel = {
        let label = UILabel()
        label.text = "RULES"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.textColor = UIColor(white: 1, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    
    lazy var rulesBackgroundText: UILabel = {
           let label = UILabel()
           label.text = "RULES"
           label.font = UIFont.systemFont(ofSize: 100, weight: .bold)
           label.textColor = UIColor(white: 0.3, alpha: 0.1)
           label.textAlignment = .center
           return label
       }()
    
    lazy var ruleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor(white: 1, alpha: 0.7)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout(){
        backgroundColor = .clear
       
        addSubview(artistImage1)
        _ = artistImage1.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: height)
        
        addSubview(artistImage2)
        _ = artistImage2.anchor(top: artistImage1.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: height)
        
        addSubview(venueBackgroundText)
        _ = venueBackgroundText.anchor(top: artistImage2.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: -32, bottomConstant: 0, rightConstant: -32, widthConstant: 0, heightConstant: 0)
        
        addSubview(descriptionLabel)
       _ = descriptionLabel.anchor(top: venueBackgroundText.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 4, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        
        addSubview(locationLabel)
        _ = locationLabel.anchor(top: venueBackgroundText.topAnchor, left: leftAnchor, bottom: venueBackgroundText.bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        
        
        addSubview(rulesBackgroundText)
       _ = rulesBackgroundText.anchor(top: descriptionLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 4, leftConstant: -32, bottomConstant: 0, rightConstant: -32, widthConstant: 0, heightConstant: 0)
        
        addSubview(rulesTextLabel)
        _ = rulesTextLabel.anchor(top: rulesBackgroundText.topAnchor, left: leftAnchor, bottom: rulesBackgroundText.bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        
        addSubview(ruleLabel)
        _ = ruleLabel.anchor(top: rulesBackgroundText.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 4, leftConstant: 16, bottomConstant: 0, rightConstant: 15, widthConstant: 0, heightConstant: 0)
    }
     
 }
     

 class ProTableViewCellSingle: UITableViewCell{
     
     var height: CGFloat = 200
     
     lazy var backgroundCard: UIView = {
         let view = UIView()
         view.backgroundColor = UIColor.CustomColors.Black.card
         view.layer.cornerRadius = 10
         view.alpha = 0.2
         return view
     }()

     var artistImage1: UIImageView = {
         let artImage = UIImageView(image: UIImage(named: "IMG_0"))
         artImage.contentMode = .scaleAspectFill
         artImage.layer.masksToBounds = true
         artImage.layer.cornerRadius = 10
         return artImage
     }()
     
     lazy var venueBackgroundText: UILabel = {
         let label = UILabel()
         label.text = "VENUE"
         label.font = UIFont.systemFont(ofSize: 100, weight: .bold)
         label.textColor = UIColor(white: 0.3, alpha: 0.1)
         label.textAlignment = .center
         return label
     }()
  
    lazy var descriptionLabel: UILabel = {
         let label = UILabel()
         label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor(white: 1, alpha: 0.7)
        label.textAlignment = .left
        label.numberOfLines = 0
     
         return label
     }()
     
     lazy var locationLabel: UILabel = {
         let label = UILabel()
         label.text = "VENUE"
         label.numberOfLines = 0
         label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
         label.textColor = UIColor(white: 1, alpha: 1)
         label.textAlignment = .center
         return label
     }()
     
     lazy var rulesTextLabel: UILabel = {
         let label = UILabel()
         label.text = "RULES"
         label.numberOfLines = 0
         label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
         label.textColor = UIColor(white: 1, alpha: 1)
         label.textAlignment = .center
         return label
     }()
     
     
     lazy var rulesBackgroundText: UILabel = {
            let label = UILabel()
            label.text = "RULES"
            label.font = UIFont.systemFont(ofSize: 100, weight: .bold)
            label.textColor = UIColor(white: 0.3, alpha: 0.1)
            label.textAlignment = .center
            return label
        }()
     
     lazy var ruleLabel: UILabel = {
         let label = UILabel()
         label.font = UIFont.systemFont(ofSize: 20)
         label.textColor = UIColor(white: 1, alpha: 0.7)
         label.textAlignment = .left
         label.numberOfLines = 0
         return label
     }()
     

     override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
         super.init(style: style, reuseIdentifier: reuseIdentifier)
         setupLayout()
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }

     func setupLayout(){
        
        if UIViewController().isSmalliPhone(){
            self.venueBackgroundText.font = UIFont.systemFont(ofSize: 80, weight: .bold)
            self.descriptionLabel.font = UIFont.systemFont(ofSize: 15)
            self.locationLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            self.rulesTextLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            self.rulesBackgroundText.font = UIFont.systemFont(ofSize: 80, weight: .bold)
            self.ruleLabel.font = UIFont.systemFont(ofSize: 15)
        }
        
         backgroundColor = .clear
        
         addSubview(artistImage1)
         _ = artistImage1.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: height)
         
         addSubview(venueBackgroundText)
         _ = venueBackgroundText.anchor(top: artistImage1.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: -32, bottomConstant: 0, rightConstant: -32, widthConstant: 0, heightConstant: 0)
         
         addSubview(descriptionLabel)
        _ = descriptionLabel.anchor(top: venueBackgroundText.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 4, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
         
         addSubview(locationLabel)
         _ = locationLabel.anchor(top: venueBackgroundText.topAnchor, left: leftAnchor, bottom: venueBackgroundText.bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
         
         
         addSubview(rulesBackgroundText)
        _ = rulesBackgroundText.anchor(top: descriptionLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 4, leftConstant: -32, bottomConstant: 0, rightConstant: -32, widthConstant: 0, heightConstant: 0)
         
         addSubview(rulesTextLabel)
         _ = rulesTextLabel.anchor(top: rulesBackgroundText.topAnchor, left: leftAnchor, bottom: rulesBackgroundText.bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
         
         addSubview(ruleLabel)
         _ = ruleLabel.anchor(top: rulesBackgroundText.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 4, leftConstant: 16, bottomConstant: 0, rightConstant: 15, widthConstant: 0, heightConstant: 0)
     }
     
 }
     
     
 class ProTableViewCellSingleHundia: UITableViewCell{

     
     lazy var backgroundCard: UIView = {
         let view = UIView()
         view.backgroundColor = UIColor.CustomColors.Black.card
         view.layer.cornerRadius = 10
         view.alpha = 0.2
         return view
     }()

     var artistImage1: UIImageView = {
         let artImage = UIImageView(image: UIImage(named: "IMG_0"))
         artImage.contentMode = .scaleAspectFill
         artImage.layer.masksToBounds = true
         artImage.layer.cornerRadius = 10
         return artImage
     }()

     
     lazy var dayLabelLabel: UILabel = {
         let label = UILabel()
         label.text = "DAY 1"
         label.font = UIFont.systemFont(ofSize: 120, weight: .bold)
         label.textColor = UIColor(white: 0.5, alpha: 0.1)
         label.textAlignment = .center
         return label
     }()

     
     lazy var artistTitlelLabel: UILabel = {
         let label = UILabel()
         label.text = "Quadrangle\n8:00 PM"
         label.numberOfLines = 0
         label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
         label.textColor = UIColor(white: 1, alpha: 1)
         label.textAlignment = .center
         return label
     }()
     

     override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
         super.init(style: style, reuseIdentifier: reuseIdentifier)
         setupLayout()
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }

     func setupLayout(){
         backgroundColor = .clear
         
         addSubview(backgroundCard)
         
         addSubview(artistImage1)
         _ = artistImage1.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 24, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 350)
         
         addSubview(dayLabelLabel)
         _ = dayLabelLabel.anchor(top: artistImage1.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 0)
         
         addSubview(artistTitlelLabel)
         _ = artistTitlelLabel.anchor(top: dayLabelLabel.topAnchor, left: leftAnchor, bottom: dayLabelLabel.bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 0)
         
         _ = backgroundCard.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 8, leftConstant: 16, bottomConstant: 8, rightConstant: 16, widthConstant: 0, heightConstant: 0)
     }
     
 }
    
    
