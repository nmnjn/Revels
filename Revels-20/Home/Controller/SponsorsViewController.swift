    //
//  SponsorsViewController.swift
//  TechTetva-19
//
//  Created by Naman Jain on 04/10/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit
import Disk
import SDWebImage
    
struct SponsorsData: Codable{
    var name: String
    var imageUrl: String
    var description: String
    var webUrl: String
}


class SponsorsViewController: UITableViewController {
    
    var homeViewController: HomeViewController?
    var sponsors = [SponsorsData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getSponsors()
    }
    
    fileprivate func setupTableView() {
        tableView.register(SponsorsTableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.CustomColors.Black.background
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: -8, left: 0, bottom: 16, right: 0)
    }
    
    func setupView(){
        let titleLabel = UILabel()
        titleLabel.text = "Sponsors"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
        setupTableView()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sponsors.count
    }
    
    func getSponsors(){
        let apiStruct = ApiStruct(url: sponsorsURL, method: .get, body: nil)
        WSManager.shared.getJSONResponse(apiStruct: apiStruct, success: { (spns: [SponsorsData]) in
            self.sponsors = spns
            self.homeViewController?.sponsors = spns
            Caching.sharedInstance.saveSponsorsToCache(sponsors: spns)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }) { (error) in
           print(error)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! SponsorsTableViewCell
        cell.titleLabel.text = sponsors[indexPath.row].name
        cell.descriptionLabel.text = sponsors[indexPath.row].description
        if let imageUrl = URL(string: sponsors[indexPath.row].imageUrl){
            cell.logoImage.sd_setImage(with: imageUrl, placeholderImage: nil)
        }
        cell.selectionStyle = .none
        guard let _ = URL(string: sponsors[indexPath.row].webUrl) else {
            cell.tapLabel.isHidden = true
            return cell
        }
        
        cell.tapLabel.isHidden = false
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = sponsors[indexPath.row].webUrl
        homeViewController?.openURL(url: url)
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


class SponsorsTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.backgroundCard.backgroundColor = selected ? UIColor.CustomColors.Black.card : UIColor.CustomColors.Black.card
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Init
    
    let backgroundCard: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        view.alpha = 0.5
        view.backgroundColor = UIColor.CustomColors.Black.card
        return view
    }()
    
    let logoImageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        return view
    }()
    
    let logoImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "decathlon")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .white
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 19)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .lightGray
        return label
    }()
    
    
    let tapLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.text = "Tap to know more."
        label.textAlignment = .center
        label.textColor = .darkGray
        return label
    }()
    
    //MARK: - Setup
    
    func setupLayout(){
        addSubview(backgroundCard)
        self.backgroundColor = .clear
        self.selectedBackgroundView = UIView()
        
        addSubview(logoImageView)
        _ = logoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 32, leftConstant: 32, bottomConstant: 16, rightConstant: 32, widthConstant: 0, heightConstant: 100)
        
        logoImageView.addSubview(logoImage)
        logoImage.fillSuperview(padding: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
        
        addSubview(titleLabel)
        _ = titleLabel.anchor(top: logoImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 16, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 0)
        
        addSubview(descriptionLabel)
        _ = descriptionLabel.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 0)
        
        addSubview(tapLabel)
        _ = tapLabel.anchor(top: descriptionLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 16, leftConstant: 32, bottomConstant: 16, rightConstant: 32, widthConstant: 0, heightConstant: 0)
        
        _ = backgroundCard.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
    }
    
    
}
