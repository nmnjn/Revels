//
//  DetailsLauncher.swift
//  TechTetva-19
//
//  Created by Vedant Jain on 26/08/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit

class DetailsLauncher: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    fileprivate let cellId = "cellId"
    
    let blackView = UIView()
    
    weak var categoryControllerInstance: CategoriesTableViewController?
    
    var category: Category?{
        didSet {
            tableView.reloadData()
        }
    }
    
    //MARK: - Setup TableView
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.CustomColors.Black.background
        tableView.layer.cornerRadius = 20
        tableView.layer.masksToBounds = true
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tableView.separatorStyle = .none
        return tableView
    }()
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let detailsView = DetailsView()
        detailsView.titleLabel.text = category?.name ?? ""
        return detailsView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    //MARK: - TableView functions
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! DayTableViewCell
        cell.dateLabel.text = "Day " + String(indexPath.item + 1)
        cell.selectionStyle = .none
        cell.backgroundColor = .black
        cell.day = indexPath.item + 1
        guard let strongRef = categoryControllerInstance else {return cell}
        cell.delegate = strongRef
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    
    //MARK: - Basic functions
    
    func setupViews() {
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 1, alpha: 0.2)
            blackView.alpha = 0
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
            blackView.addGestureRecognizer(tap)
            
            window.addSubview(blackView)
            window.addSubview(tableView)
            
            blackView.frame = window.frame
            tableView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 500)
        }
    }
    
    func showDetails() {
        setupViews()
        if let window = UIApplication.shared.keyWindow {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.blackView.alpha = 0.5
                self.tableView.frame = CGRect(x: 0, y: window.frame.height-500, width: window.frame.width, height: 500)
            }, completion: nil)
        }
    }
    
    @objc func handleDismiss() {
        if let window = UIApplication.shared.keyWindow {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.blackView.alpha = 0
                self.tableView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 500)
            }, completion: nil)
        }
    }
    
    fileprivate func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DayTableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    override init() {
        super.init()
        setupTableView()
    }
    
}

