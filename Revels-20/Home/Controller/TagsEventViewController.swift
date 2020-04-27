//
//  TagsEventViewController.swift
//  Revels-20
//
//  Created by Naman Jain on 29/01/20.
//  Copyright © 2020 Naman Jain. All rights reserved.
//

import UIKit
import AudioToolbox

struct taggedEvents: Decodable{
    let name: String
    let tags: [String]
}

class TagsEventsViewController: UIViewController, TagsControllerDelegate, UITableViewDelegate, UITableViewDataSource{
    
    let slideInTransitioningDelegate = SlideInPresentationManager(from: UIViewController(), to: UIViewController())
    var events = [Event]()
    
    var tags = [String]()
    
    var filteredEvents: [Event]?{
        didSet{
            guard let events = filteredEvents else { return }
//            self.eventsTableView.reloadData(with: .automatic)
            UIView.transition(with: eventsTableView,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: { self.eventsTableView.reloadData() })
        }
    }
    
    func didTapTag(indexPath: IndexPath) {
        print(tags[indexPath.row])
        let tag = tags[indexPath.row]
        if tag == "All"{
            self.filteredEvents = self.events
            return
        }
        self.filteredEvents = self.events.filter({ (event) -> Bool in
            event.tags!.contains(tag)
        })
    }
    
    lazy var eventsTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.backgroundColor = UIColor.CustomColors.Black.background
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 8, right: 0)
        return tableView
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate let tagsController = TagsController(collectionViewLayout: UICollectionViewFlowLayout())
    
    fileprivate let cellId = "cellId"
    fileprivate let menuCellId = "menuCellId"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        self.events = Caching.sharedInstance.getEventsFromCache()
        self.tags = Caching.sharedInstance.getTagsFromCache()
        setupTagsController()
        setupLayout()
        setupNavigationBar()
        self.filteredEvents = self.events
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        updateStatusBar()
    }
    
    private var themedStatusBarStyle: UIStatusBarStyle?
    
    func updateStatusBar(){
        themedStatusBarStyle = .lightContent
        setNeedsStatusBarAppearanceUpdate()
    }
    
    fileprivate func setupNavigationBar(){
        self.navigationItem.title = "Events"
    }
    
    fileprivate func setupTagsController() {
        tagsController.delegate = self
        tagsController.tags = self.tags
        tagsController.markerBar.backgroundColor = UIColor.CustomColors.Blue.accent
        tagsController.specialColor = UIColor.CustomColors.Blue.accent
        tagsController.menuBar.backgroundColor = UIColor.CustomColors.Black.background
        tagsController.collectionView.backgroundColor = UIColor.CustomColors.Black.background
        tagsController.shadowBar.backgroundColor = UIColor.CustomColors.Black.background
    }
    
    fileprivate func setupLayout() {
        let tagsView = tagsController.view!
        tagsView.backgroundColor = .white
        view.addSubview(tagsView)
        _ = tagsView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
        tagsController.collectionView.selectItem(at: [0, 0], animated: true, scrollPosition: .centeredHorizontally)
        
        view.backgroundColor = UIColor.CustomColors.Black.background
        
        view.addSubview(eventsTableView)
        eventsTableView.anchor(top: tagsView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredEvents?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CategoryTableViewCell
        cell.titleLabel.text = filteredEvents?[indexPath.row].name ?? ""
        var desc = filteredEvents?[indexPath.row].longDesc ?? ""
        if desc == "" {
            desc = filteredEvents?[indexPath.row].shortDesc ?? ""
        }
        cell.descriptionLabel.text = desc
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let event = filteredEvents?[indexPath.row]{
            self.handleEventTap(withEvent: event)
        }
    }
    
    func handleEventTap(withEvent event: Event){
        AudioServicesPlaySystemSound(1519)
        let eventViewController = EventsViewController()
        slideInTransitioningDelegate.categoryName = "\(event.shortDesc)"
        eventViewController.modalPresentationStyle = .custom
        eventViewController.transitioningDelegate = slideInTransitioningDelegate
        eventViewController.event = event
        eventViewController.schedule = nil
        eventViewController.tagsEventController = self
        present(eventViewController, animated: true, completion: nil)
        print(event.id)
        print(event.name)
    }
    
    func performPaymentFor(delegateCardID: Int){
        let vc = PaymentsWebViewController()
        vc.delegateCardID = delegateCardID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

protocol TagsControllerDelegate {
    func didTapTag(indexPath: IndexPath)
}

class TagsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let cellId = "cellId"
    
    var tags: [String]?{
        didSet{
            collectionView.reloadData()
            collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        }
    }
    var specialColor: UIColor?
    
    var delegate: TagsControllerDelegate?
    
    let menuBar: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    lazy var markerBar: UIView = {
        let v = UIView()
        v.backgroundColor = .black
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let shadowBar: UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        return v
    }()
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        delegate?.didTapTag(indexPath: indexPath)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: cellId)
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = -8
            layout.minimumInteritemSpacing = -8
        }
        collectionView.showsHorizontalScrollIndicator = false
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TagCell
        cell.label.text = tags?[indexPath.item] ?? ""
        if let color = specialColor{
            cell.color = color
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //UIFont.systemFont(ofSize: 16, weight: .regular)
        let tag = self.tags?[indexPath.item] ?? ""
        let width: CGFloat!
        if isSmalliPhone(){
            width = tag.width(withConstrainedHeight: 35, font: UIFont.systemFont(ofSize: 13, weight: .regular)) + 40
        }else{
            width = tag.width(withConstrainedHeight: 35, font: UIFont.systemFont(ofSize: 16, weight: .regular)) + 48
        }
        
        return .init(width: width, height: 40)
    }
    
}


extension String {
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}


class TagCell: UICollectionViewCell {
    
    var color: UIColor?{
        didSet {
            if isSelected{
                label.textColor = color
                backgroundCardView.layer.borderColor = color?.cgColor
            }
        }
    }
    let backgroundCardView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.0628238342, green: 0.0628238342, blue: 0.0628238342, alpha: 1)
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 0.15
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    
    let label: UILabel = {
        let l = UILabel()
        l.text = "Tag"
        l.textAlignment = .center
        l.textColor = .lightGray
        l.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return l
    }()
    
    override var isSelected: Bool {
        didSet {
            label.textColor = isSelected ? color ?? .black : .lightGray
            if UIViewController().isSmalliPhone(){
                label.font = isSelected ? UIFont.systemFont(ofSize: 12, weight: .medium) : UIFont.systemFont(ofSize: 12, weight: .regular)
            }else{
                label.font = isSelected ? UIFont.systemFont(ofSize: 14, weight: .medium) : UIFont.systemFont(ofSize: 14, weight: .regular)
            }
            backgroundCardView.layer.borderColor = isSelected ? color?.cgColor : UIColor.lightGray.cgColor
            backgroundCardView.layer.borderWidth = isSelected ? 0.7 : 0.15
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if UIViewController().isSmalliPhone(){
            label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        }
        addSubview(backgroundCardView)
        backgroundCardView.anchorWithConstants(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 8)
        backgroundCardView.addSubview(label)
        label.anchorWithConstants(top: backgroundCardView.topAnchor, left: backgroundCardView.leftAnchor, bottom: backgroundCardView.bottomAnchor, right: backgroundCardView.rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 8)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
