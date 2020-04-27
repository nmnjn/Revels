//
//  ResultsViewController.swift
//  TechTetva-19
//
//  Created by Naman Jain on 26/08/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit
import Disk

class ResultsViewController: UICollectionViewController {
    
    //MARK: - Properties
    
    fileprivate let reuseIdentifier = "reuseIdentifier"
    
    var eventsDictionary = [Int: Event]()
    var resultsDictionary = [Int: [Result]]()
    
    var eventsWithResults = [Event]()
    var filteredEventsWithResults = [Event]()
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let popUp = SpinnerPopUp()
    var isEmpty = false
    
    
    //MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupView()
        setupCollectionView()
        setupSearchBar()
        refreshResults()
        
    }
    
    var startTime : TimeInterval?
    
    override func viewDidAppear(_ animated: Bool) {
        if let time = startTime{
            let time1 = Date(timeIntervalSince1970: time)
            let time2 = Date()
            let difference = Calendar.current.dateComponents([.second], from: time1, to: time2)
            let duration = difference.second
            if duration ?? 0 > 600{
                self.refreshResults()
                self.startTime = Date().timeIntervalSince1970
            }
        }else{
            startTime = Date().timeIntervalSince1970
        }

    }
    
    
    //MARK: - Layout Setup Functions
    
    fileprivate func setupNavigationBar(){
        let titleLabel = UILabel()
        titleLabel.text = "Results"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.sizeToFit()
        let leftItem = UIBarButtonItem(customView: titleLabel)
        self.navigationItem.leftBarButtonItem = leftItem
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshResults))
    }
    
    
    fileprivate func setupView(){
        view.backgroundColor = UIColor.CustomColors.Black.background
    }
    
    fileprivate func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.CustomColors.Black.background
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.register(ResultsCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(NoResultsCell.self, forCellWithReuseIdentifier: "NoResultsCell")
    }
    
    fileprivate func setupSearchBar(){
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Events"
        searchController.searchBar.searchBarStyle = .default
        searchController.searchBar.sizeToFit()
        searchController.searchBar.keyboardAppearance = UIKeyboardAppearance.dark
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        searchController.searchBar.barStyle = UIBarStyle.black
        textFieldInsideSearchBar?.textColor = .white
        searchController.searchBar.tintColor = UIColor.CustomColors.Blue.accent
        
        definesPresentationContext = true
    }
    
    
    // MARK: - Data Functions
    
    @objc func refreshResults(){
        isEmpty = false
        self.eventsDictionary = [:]
        self.resultsDictionary = [:]
        self.eventsWithResults = []
        self.filteredEventsWithResults = []
        collectionView.reloadData()
//        collectionView.addSubview(popUp)
        view.addSubview(popUp)
//        UIApplication.shared.keyWindow?.addSubview(popUp)
        getCachedEventsDictionary()
    }
    
    func getCachedEventsDictionary(){
        do{
            let retrievedEventsDictionary = try Disk.retrieve("eventsDictionary.json", from: .caches, as: [Int: Event].self)
            self.eventsDictionary = retrievedEventsDictionary
            self.getResults()
        }catch let error{
            self.getEvents()
            print(error)
        }
    }
    
    fileprivate func getResults(){
        Networking.sharedInstance.getResults(dataCompletion: { (data) in
            if data.count == 0{
                self.isEmpty = true
            }
            for result in data{
                self.resultsDictionary[result.event] = []
            }
            
            for key in self.resultsDictionary.keys{
                if let event = self.eventsDictionary[key]{
                    self.eventsWithResults.append(event)
                }
                //                self.eventsWithResults.append(self.eventsDictionary[key]!)
            }
            
            for event in self.eventsWithResults{
                for result in data{
                    if result.event == event.id{
                        self.resultsDictionary[event.id]?.append(result)
                    }
                }
            }
            
            self.eventsWithResults.sort(by: { (event1, event2) -> Bool in
                event1.name < event2.name
            })
            
            DispatchQueue.main.async {
                self.popUp.hideSpinner()
                self.collectionView.reloadData()
            }
            
        }) { (errorMessage) in
            print(errorMessage)
        }
    }
    
    fileprivate func getEvents(){
        Networking.sharedInstance.getData(url: eventsURL, decode: Event(), dataCompletion: { (data) in
            for event in data{
                self.eventsDictionary[event.id] = event
            }
            self.saveEventsDictionaryToCache()
            self.getResults()
        }) { (errorMessage) in
            print(errorMessage)
        }
    }
    
    func saveEventsDictionaryToCache(){
        do{
            try Disk.save(self.eventsDictionary, to: .caches, as: "eventsDictionary.json")
        }catch let error{
            print(error)
        }
    }
    
    
    //MARK: - Selector Handlers
}

extension ResultsViewController: UISearchResultsUpdating {
    
    @objc func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    @objc func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        filteredEventsWithResults = eventsWithResults.filter({ (event: Event) -> Bool in
            return event.name.lowercased().contains(searchText.lowercased())
        })
        collectionView.reloadData()
    }
    
    @objc func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}


extension ResultsViewController: UICollectionViewDelegateFlowLayout{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isEmpty{
            return 1
        }
        return isFiltering() ? filteredEventsWithResults.count : eventsWithResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isEmpty{
            return .init(width: view.frame.width, height: 300)
        }
        var width : CGFloat = 0
        if isSmalliPhone(){
            width = (view.frame.width - 32) / 2
        }else{
            width = (view.frame.width - 48) / 3
        }
        return .init(width: width, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isEmpty{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoResultsCell", for: indexPath) as! NoResultsCell
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ResultsCell
        let selectedEventId = isFiltering() ? filteredEventsWithResults[indexPath.item].id : eventsWithResults[indexPath.item].id
        cell.event = self.eventsDictionary[selectedEventId]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if eventsWithResults.count == 0{
            return
        }
        let selectedEvent = isFiltering() ? filteredEventsWithResults[indexPath.item] : eventsWithResults[indexPath.item]
        
        let resultsDetailViewController = ResultsDetailViewController(collectionViewLayout: UICollectionViewFlowLayout())
        print(selectedEvent.name)
        resultsDetailViewController.event = selectedEvent
        resultsDetailViewController.results = self.resultsDictionary[selectedEvent.id]
        navigationController?.pushViewController(resultsDetailViewController, animated: true)
        
    }
    
}


class SpinnerPopUp: UIView {
    
    var constant : Int?
    
    lazy var spinnerView : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .white)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.frame = UIScreen.main.bounds
        addSubview(spinnerView)
        spinnerView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -128).isActive = true
        spinnerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        spinnerView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4).isActive = true
        spinnerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7).isActive = true
        spinnerView.startAnimating()
    }
    
    @objc func hideSpinner(){
        self.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
