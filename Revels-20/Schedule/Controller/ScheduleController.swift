//
//  ScheduleController.swift
//  TechTetva-19
//
//  Created by Naman Jain on 26/08/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit
import Disk
import AudioToolbox


class ScheduleController: UICollectionViewController, UICollectionViewDelegateFlowLayout, MenuControllerDelegate  {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var fromFavorite = false
    var favouritesDict = [String: Bool]()
    
    var categoryID: Int?
    var category: Category?
    var fromCategory = false
    
    var eventsDictionary = [Int: Event]()
    var schedule = [Schedule]()
    var dayOneSchedule = [Schedule]()
    var dayTwoSchedule = [Schedule]()
    var dayThreeSchedule = [Schedule]()
    var dayFourSchedule = [Schedule]()
    
    func didTapMenuItem(indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    fileprivate let menuController = MenuController(collectionViewLayout: UICollectionViewFlowLayout())
    
    fileprivate let cellId = "cellId"
    fileprivate let menuCellId = "menuCellId"
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let offset = x / CGFloat(menuController.menuItems.count)
        menuController.menuBar.transform = CGAffineTransform(translationX: offset, y: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.refreshFavs()
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
        
        setupMenuController()
        setupLayout()
        getScheduleData()
        if fromCategory{
            self.navigationItem.title = category?.name
        }else if fromFavorite{
            self.navigationItem.title = "Favourites"
            self.navigationController?.navigationBar.tintColor = UIColor.CustomColors.Skin.accent
        }else{
            setupNavigationBar()
            setupFavouritesBarButton()
        }
        
        showInfoOptions()
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    @objc func showInfoOptions(){
        if !UserDefaults.standard.bool(forKey: "firstSchedule"){
            DispatchQueue.main.async(execute: {
                let alertController = UIAlertController(title: "Welcome to the Schedules Tab", message: "• You can checkout the day wise schedule of Revels from here.\n\n• Tap on an Event Schedule to view more information about it, register for the event and view its delegate card.\n\n• You can star the events and access them later through the favourites section!", preferredStyle: .actionSheet)
                
                let okayAction = UIAlertAction(title: "Continue", style: .cancel, handler: { (_) in
                    
                })
                alertController.addAction(okayAction)
                self.present(alertController, animated: true, completion: nil)
            })
        }
        
        UserDefaults.standard.set(true, forKey: "firstSchedule")
        UserDefaults.standard.synchronize()
    }
    
    fileprivate func setupNavigationBar(){
        let titleLabel = UILabel()
        titleLabel.text = "Schedule"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        let leftItem = UIBarButtonItem(customView: titleLabel)
        self.navigationItem.leftBarButtonItem = leftItem
    }
    
    fileprivate func setupFavouritesBarButton(){
        if let favsDict = UserDefaults.standard.dictionary(forKey: "favDictionary") as? [String: Bool]{
            if favsDict.count > 0{
                print(favsDict)
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "star_filled")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(toggleFavourites))//UIBarButtonItem(title: "Favourites", style: .plain, target: self, action: #selector(toggleFavourites))
                self.navigationItem.rightBarButtonItem?.tintColor = UIColor.CustomColors.Skin.accent
                return
            }
        }
        self.navigationItem.rightBarButtonItem = nil
    }
    
    func refreshFavs(){
        if let favsDict = UserDefaults.standard.dictionary(forKey: "favDictionary") as? [String: Bool]{
            self.favouritesDict = favsDict
            self.collectionView.reloadData()
        }
    }
    
    @objc func toggleFavourites(){
        let favScheduleVC = ScheduleController(collectionViewLayout: UICollectionViewFlowLayout())
        favScheduleVC.fromFavorite = true
        if let favsDict = UserDefaults.standard.dictionary(forKey: "favDictionary") as? [String: Bool]{
            favScheduleVC.favouritesDict = favsDict
        }
        
        self.navigationController?.pushViewController(favScheduleVC, animated: true)
    }
    
    fileprivate func setupMenuController() {
        menuController.delegate = self
        menuController.menuItems = ["Day 1", "Day 2", "Day 3", "Day 4"]
        menuController.markerBar.backgroundColor = UIColor.CustomColors.Blue.accent
        menuController.specialColor = UIColor.CustomColors.Blue.accent
        menuController.menuBar.backgroundColor = UIColor.CustomColors.Black.background
        menuController.collectionView.backgroundColor = UIColor.CustomColors.Black.background
        menuController.shadowBar.backgroundColor = UIColor.CustomColors.Black.background
        
        if fromFavorite{
            menuController.markerBar.backgroundColor = UIColor.CustomColors.Skin.accent
            menuController.specialColor = UIColor.CustomColors.Skin.accent
        }
    }
    
    fileprivate func setupLayout() {
        let menuView = menuController.view!
        menuView.backgroundColor = .white
        view.addSubview(menuView)
        _ = menuView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
        menuController.collectionView.selectItem(at: [0, 0], animated: true, scrollPosition: .centeredHorizontally)
        
        view.backgroundColor = UIColor.CustomColors.Black.background
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
        }
        
        collectionView.backgroundColor = UIColor.CustomColors.Black.background
        collectionView.anchor(top: menuView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        collectionView.register(DayWiseScheduleCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.isPagingEnabled = true
        collectionView.allowsSelection = true
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuController.menuItems.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DayWiseScheduleCell
        switch indexPath.item {
        case 0:
            if fromCategory{
                cell.schedule = dayOneSchedule.filter({ (scheduleItem) -> Bool in
                    if let category = eventsDictionary[scheduleItem.eventId]?.category{
                        if category == self.categoryID{
                            return true
                        }
                    }
                    return false
                })
            }else if fromFavorite{
                cell.schedule = dayOneSchedule.filter({ (scheduleItem) -> Bool in
                    return (self.favouritesDict["\(scheduleItem.eventId)"] ?? false)
                })
            }else{
                cell.schedule = dayOneSchedule
            }
        case 1:
            if fromCategory{
                cell.schedule = dayTwoSchedule.filter({ (scheduleItem) -> Bool in
                    if let category = eventsDictionary[scheduleItem.eventId]?.category{
                        if category == self.categoryID{
                            return true
                        }
                    }
                    return false
                })
            }else if fromFavorite{
                cell.schedule = dayTwoSchedule.filter({ (scheduleItem) -> Bool in
                    return (self.favouritesDict["\(scheduleItem.eventId)"] ?? false)
                })
            }else{
                cell.schedule = dayTwoSchedule
            }
        case 2:
            if fromCategory{
                cell.schedule = dayThreeSchedule.filter({ (scheduleItem) -> Bool in
                    if let category = eventsDictionary[scheduleItem.eventId]?.category{
                        if category == self.categoryID{
                            return true
                        }
                    }
                    return false
                })
            }else if fromFavorite{
                cell.schedule = dayThreeSchedule.filter({ (scheduleItem) -> Bool in
                    return (self.favouritesDict["\(scheduleItem.eventId)"] ?? false)
                })
            }else{
                cell.schedule = dayThreeSchedule
            }
        case 3:
            if fromCategory{
                cell.schedule = dayFourSchedule.filter({ (scheduleItem) -> Bool in
                    if let category = eventsDictionary[scheduleItem.eventId]?.category{
                        if category == self.categoryID{
                            return true
                        }
                    }
                    return false
                })
            }else if fromFavorite{
                cell.schedule = dayFourSchedule.filter({ (scheduleItem) -> Bool in
                    return (self.favouritesDict["\(scheduleItem.eventId)"] ?? false)
                })
            }else{
                cell.schedule = dayFourSchedule
            }
        default:
            cell.schedule = nil
        }
        cell.schedule = cell.schedule?.sorted(by: { (sc1, sc2) -> Bool in
            sc1.start < sc2.start
        })
        cell.eventsDictionary = self.eventsDictionary
        cell.scheduleController = self
        cell.fromFavourite = self.fromFavorite
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: view.frame.height - 50)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if fromCategory{
            self.dismiss(animated: true)
        }
    }
    
    //MARK: - Data Functions
    
    func getScheduleData(){
        Caching.sharedInstance.getCachedData(dataType: [Int: Event](), cacheLocation: eventsDictionaryCache, dataCompletion: { (data) in
            self.eventsDictionary = data
            self.getCachedSchedule()
        }) { (error) in
            print(error)
            //fetch events here and cache them
        }
    }
    
    func getCachedSchedule(){
        Caching.sharedInstance.getCachedData(dataType: [Schedule](), cacheLocation: scheduleCache, dataCompletion: { (data) in
            self.schedule = data
            self.parseScheduleIntoDays()
        }) { (error) in
            print(error)
            self.getSchedule()
        }
    }
    
    fileprivate func getSchedule(){
        Networking.sharedInstance.getData(url: scheduleURL, decode: Schedule(), dataCompletion: { (data) in
            self.schedule = data
        }) { (errorMessage) in
            print(errorMessage)
        }
    }
    
    func parseScheduleIntoDays(){
        for item in schedule {
            let formatter = DateFormatter()
            var startDate = Date(dateString: item.start)
            startDate = Calendar.current.date(byAdding: .hour, value: -5, to: startDate)!
            startDate = Calendar.current.date(byAdding: .minute, value: -30, to: startDate)!
            formatter.dateFormat = "EEEE"
            let dayString = formatter.string(from: startDate)
            switch (dayString){
            case "Wednesday":
                dayOneSchedule.append(item)
            case "Thursday":
                dayTwoSchedule.append(item)
            case "Friday":
                dayThreeSchedule.append(item)
            case "Saturday":
                dayFourSchedule.append(item)
            default:
                print("no day found")
            }
        }
    }
    
    let slideInTransitioningDelegate = SlideInPresentationManager(from: UIViewController(), to: UIViewController())
    
    func handleEventTap(withEvent event: Event, withSchedule schedule: Schedule){
        AudioServicesPlaySystemSound(1519)
        let eventViewController = EventsViewController()
        slideInTransitioningDelegate.categoryName = "\(event.shortDesc)"
        eventViewController.modalPresentationStyle = .custom
        eventViewController.transitioningDelegate = slideInTransitioningDelegate
        eventViewController.event = event
        eventViewController.schedule = schedule
        eventViewController.scheduleController = self
        present(eventViewController, animated: true, completion: nil)
        if fromCategory{
//            self.dismiss(animated: true)
        }
        print(event.id)
        print(event.name)
    }
    
    func performPaymentFor(delegateCardID: Int){
        let vc = PaymentsWebViewController()
        vc.delegateCardID = delegateCardID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}



class DayWiseScheduleCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    
    weak var scheduleController: ScheduleController?
    var fromFavourite: Bool?
    var results = [Result]()
    var eventsDictionary = [Int: Event]()
    var schedule : [Schedule]?{
        didSet{
            guard let schedule = schedule else { return}
            tableView.reloadData()
            isEmpty = schedule.count == 0
        }
    }
    var isEmpty = false
    fileprivate let cellId = "cellId"
    fileprivate let noEventCellId = "noEventCellId"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.CustomColors.Black.background
        setupTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Setup Functions
    
    fileprivate func setupTableView(){
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: cellId)
        tableView.register(NoEventCell.self, forCellReuseIdentifier: noEventCellId)
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = UIColor.CustomColors.Black.background
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        addSubview(tableView)
        tableView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
    
    // MARK: - TableView Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if schedule?.count == 0{
            isEmpty = true
            return 1
        }
        return schedule?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isEmpty{
            let cell = tableView.dequeueReusableCell(withIdentifier: noEventCellId, for: indexPath) as! NoEventCell
            if fromFavourite ?? false{
                cell.label.text = "No Favourite Events"
            }else{
                cell.label.text = "no events on this day"
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ScheduleCell
            cell.favourite = false
            if let selectedSchedule = self.schedule?[indexPath.row]{
                cell.schedule = selectedSchedule
                if let selectedEvent = self.eventsDictionary[selectedSchedule.eventId]{
                    cell.event = selectedEvent
                }
                if let favsDictionary = UserDefaults.standard.dictionary(forKey: "favDictionary") as? [String: Bool]{
                    cell.favourite = favsDictionary["\(selectedSchedule.eventId)"]
                }
            }
            cell.delegate = self
            guard let fav = fromFavourite else { return cell}
            if fav{
                cell.lineSeperator.backgroundColor = UIColor.CustomColors.Skin.accent
            }else{
                cell.lineSeperator.backgroundColor = UIColor.CustomColors.Blue.accent
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isEmpty{
            tableView.isScrollEnabled = false
            return self.frame.height/1.5
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEmpty{
            return
        }
        
        if let selectedSchedule = self.schedule?[indexPath.row]{
            if let selectedEvent = self.eventsDictionary[selectedSchedule.eventId]{
                self.scheduleController?.handleEventTap(withEvent: selectedEvent, withSchedule: selectedSchedule)
            }
        }
    }
}

extension DayWiseScheduleCell: ScheduleCellProtocol{
    
    func favouritesButtonTapped(cell: UITableViewCell, fav: Bool) {
        if let indexPath = tableView.indexPath(for: cell){
            if let eventID = schedule?[indexPath.row].eventId{
                var favsDictionary = [String: Bool]()
                if let favsDict = UserDefaults.standard.dictionary(forKey: "favDictionary") as? [String: Bool]{
                    favsDictionary = favsDict
                }
                favsDictionary["\(eventID)"] = fav
                UserDefaults.standard.set(favsDictionary, forKey: "favDictionary")
                UserDefaults.standard.synchronize()
                self.scheduleController?.refreshFavs()
                if fromFavourite ?? true{
//                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }else{
                    if scheduleController?.navigationItem.rightBarButtonItem == nil{
                        self.scheduleController?.setupFavouritesBarButton()
                    }
                }
                
            }
        }
    }
    
}
