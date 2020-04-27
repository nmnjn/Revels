
//
//  collegeSearchTableViewController.swift
//  Revels-20
//
//  Created by Akhilesh Shenoy on 19/02/20.
//  Copyright © 2020 Naman Jain. All rights reserved.
//

import UIKit

struct collegesData: Codable {
    var id: Int
    var name: String
    var MAHE: Int
    var hidden: Int
}

struct collegeDataResponse: Decodable{
    let success: Bool
    let data: [collegesData]
}

class collegeSearchTableViewController: UITableViewController {

    var collegeDelegate:collegeSelected? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if filteredColleges.count == 0{
            self.setupColleges()
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(collegeTableViewCell.self, forCellReuseIdentifier: "cellID")
        tableView.register(noCollegeTableViewCell.self, forCellReuseIdentifier: "cellID2")
        tableView.backgroundColor = UIColor.CustomColors.Black.background
        tableView.tableFooterView = UIView()
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .lightGray
    }
    
    var colleges = [String]()
    var maheColleges = [String]()
    var filteredColleges = [String]()
    var isSearching = false
    
    // MARK: - Table view data source
    func setupColleges(){
        let apiStruct = ApiStruct(url: collegeDataURL, method: .get, body: nil)
        WSManager.shared.getJSONResponse(apiStruct: apiStruct, success: { (map: collegeDataResponse) in
            if map.success{
                for i in map.data{
                    self.colleges.append(i.name)
                    if(i.MAHE == 1)
                    {
                        self.maheColleges.append(i.name)
                    }
                }
                self.colleges.sort()
                self.maheColleges.sort()
                self.filteredColleges = self.colleges
               
                self.tableView.reloadData(with: .automatic)
            }
        }) { (error) in
            print(error)
        }
    }
  
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .black
        let label = UILabel()
        
        if !isSearching && section == 0
        {
            label.text =  "MAHE Colleges"
        }
        else
        {
            label.text =  "All Colleges"
        }
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 20)
        view.addSubview(label)
        label.fillSuperview(padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))

        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if isSearching && filteredColleges.count == 0
        {
            return 0
        }
        return 40
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isSearching
        {
            return 1
        }
        return 2
    }
    

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if !isSearching
        {
            if section == 0
            {
                return maheColleges.count
            }
        }
        if filteredColleges.count == 0 && isSearching
        {
            return 1
        }
        return filteredColleges.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var college = ""
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! collegeTableViewCell
        if !isSearching
        {
            if indexPath.section == 0
            {
                college = maheColleges[indexPath.row]
            }
            else
            {
                 college = filteredColleges[indexPath.row]
            }
        }
        else
        {
            if filteredColleges.count == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellID2", for: indexPath) as! noCollegeTableViewCell
                tableView.allowsSelection = false
                tableView.separatorStyle = .none
                return cell
            }
            else{
                college = filteredColleges[indexPath.row]
            }
        }
        cell.textLabel?.text = college
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if !isSearching && indexPath.section == 0{
            collegeDelegate?.collegeTapped(name: maheColleges[indexPath.row])
        }
        else{
            collegeDelegate?.collegeTapped(name: filteredColleges[indexPath.row])
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension collegeSearchTableViewController:UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        self.view.isHidden = false
        if searchText != ""
        {
            isSearching = true
        }
        else
        {
            isSearching = false
        }
        filteredColleges = searchText == "" ? colleges : colleges.filter({ (college) -> Bool in
            college.lowercased().contains(searchText.lowercased())
        })
        if filteredColleges.count>0{
            tableView.allowsSelection = true
            tableView.separatorStyle = .singleLine
        }
        tableView.reloadData()
    }
}
