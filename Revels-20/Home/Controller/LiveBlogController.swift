//
//  LiveBlogController.swift
//  TechTetva-19
//
//  Created by Naman Jain on 01/10/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit
import Disk


class LiveBlogController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    let popUp = SpinnerPopUp()
    
    fileprivate func setupTableView() {
        tableView.register(ImageBlogTableViewCell.self, forCellReuseIdentifier: "ImageBlogTableViewCell")
        tableView.register(NoImageBlogTableViewCell.self, forCellReuseIdentifier: "NoImageBlogTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.CustomColors.Black.background
        tableView.tableFooterView = UIView()
//        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = UIColor.CustomColors.Blue.accent
    }
    
    func setupView(){
        let titleLabel = UILabel()
        titleLabel.text = "Live Blog"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
        //        let leftItem = UIBarButtonItem(customView: titleLabel)
        //        self.navigationItem.leftBarButtonItem = leftItem
        setupTableView()
        getBlogUpdates()
        view.addSubview(popUp)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshResults))
    }
    @objc func refreshResults(){
        self.liveBlog = []
        view.addSubview(popUp)
        getBlogUpdates()
    }
    
    var liveBlog : [Blog]?{
        didSet{
            tableView.reloadData()
            self.popUp.hideSpinner()
        }
    }
    
    func getBlogUpdates(){
        Networking.sharedInstance.getLiveBlogData(dataCompletion: { (data) in
            self.liveBlog = data
        }) { (errorMessage) in
            print(errorMessage)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return liveBlog?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let blog = liveBlog?[indexPath.row] else { return UITableViewCell() }
        if blog.imageURL == ""{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoImageBlogTableViewCell", for: indexPath) as! NoImageBlogTableViewCell
            cell.authorLabel.text = blog.author
            cell.contentLabel.text = blog.content
            cell.timeStampLabel.text = blog.timestamp
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageBlogTableViewCell", for: indexPath) as! ImageBlogTableViewCell
            cell.authorLabel.text = blog.author
            cell.contentLabel.text = blog.content
            cell.timeStampLabel.text = blog.timestamp
            if let url = NSURL(string: blog.imageURL){
                cell.mainImageView.sd_setImage(with: url as URL, placeholderImage:nil)
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        updateStatusBar()
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


class NoImageBlogTableViewCell: UITableViewCell{
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "wefojweofewfboewbfojew bjewfewf beow foewbf ewofweofbew wef"
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
        label.text = "Autho"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines = 0
        label.textColor = .lightGray
        return label
    }()
    
    let timeStampLabel: UILabel = {
        let label = UILabel()
        label.text = "TimeStamp"
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.textColor = .darkGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        addSubview(contentLabel)
        contentLabel.anchorWithConstants(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16)
        
        addSubview(authorLabel)
        authorLabel.anchorWithConstants(top: contentLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 16, bottomConstant: 0, rightConstant: 16)
        
        addSubview(timeStampLabel)
        timeStampLabel.anchorWithConstants(top: authorLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 4, leftConstant: 16, bottomConstant: 16, rightConstant: 16)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ImageBlogTableViewCell: UITableViewCell{
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "wefojweofewfboewbfojew bjewfewf beow foewbf ewofweofbew wef"
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
        label.text = "Autho"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines = 0
        label.textColor = .lightGray
        return label
    }()
    
    let timeStampLabel: UILabel = {
        let label = UILabel()
        label.text = "TimeStamp"
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.textColor = .darkGray
        return label
    }()
    
    lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.CustomColors.Black.card
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        addSubview(contentLabel)
        contentLabel.anchorWithConstants(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16)
        
        addSubview(mainImageView)
        _ = mainImageView.anchor(top: contentLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 200)
        
        addSubview(authorLabel)
        authorLabel.anchorWithConstants(top: mainImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16)
        
        addSubview(timeStampLabel)
        timeStampLabel.anchorWithConstants(top: authorLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 4, leftConstant: 16, bottomConstant: 16, rightConstant: 16)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
