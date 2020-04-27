//
//  DeveloperViewController.swift
//  TechTetva-19
//
//  Created by Naman Jain on 02/10/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit
import Disk
import SDWebImage
import SafariServices

struct Developer {
    let name: String
    let domain: String
    let imageURL: String
    let post: String
    let instaURL: String
    let linkdinURL: String
}

/*
 https://i.ibb.co/Hz23WNq/FB-IMG-1539010471675.jpg
 https://i.ibb.co/gFHQCS4/IMG-20190922-175740-Bokeh.jpg
 https://i.ibb.co/rxgN4qx/Whats-App-Image-2020-02-21-at-5-31-30-PM.jpg
 https://i.ibb.co/wQMTFcy/Whats-App-Image-2020-02-21-at-5-31-37-PM.jpg
 https://i.ibb.co/MG71RRQ/Whats-App-Image-2020-02-21-at-5-36-29-PM.jpg
 https://i.ibb.co/gj2qhQt/Whats-App-Image-2020-02-21-at-5-54-58-PM.jpg
 https://i.ibb.co/K7fWNMJ/Whats-App-Image-2020-02-21-at-5-56-45-PM.jpg
 https://i.ibb.co/W6yHcCC/Whats-App-Image-2020-02-21-at-5-57-57-PM.jpg
 https://i.ibb.co/PgfJXWL/Whats-App-Image-2020-02-21-at-6-17-49-PM.jpg
 
 */

class DeveloperViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
        
    fileprivate let cellID = "cellID"
    var homeViewController: HomeViewController?
    let developersData = [
      Developer(name: "Akhilesh", domain: "iOS", imageURL: "https://i.ibb.co/W6yHcCC/Whats-App-Image-2020-02-21-at-5-57-57-PM.jpg", post: "Category Head", instaURL: "https://www.instagram.com/akhileshxxenoy/", linkdinURL: "https://www.linkedin.com/in/akhilesh-shenoy-a2255a15a"),
      Developer(name: "Naman", domain: "iOS", imageURL: "https://i.ibb.co/3smxM9H/3ca88642-d267-4d7a-b501-68cab846e839.jpg", post: "Category Head", instaURL: "https://www.instagram.com/nxmxnjxxn/", linkdinURL: "https://www.linkedin.com/in/naman-jain-3252aa147/"),
      Developer(name: "Akshit", domain: "Android", imageURL: "https://res.cloudinary.com/nxmxnjxxn/image/upload/v1569992349/akshit.jpg", post: "Category Head", instaURL: "https://www.instagram.com/akshit.saxenamide/", linkdinURL: "https://www.linkedin.com/in/akshit-saxena-b6b613184/"),
      Developer(name: "Arihant", domain: "Android", imageURL: "https://i.ibb.co/c6T8BXN/Whats-App-Image-2020-02-21-at-11-44-08-PM.jpg", post: "Category Head", instaURL: "https://www.instagram.com/ajarihantjain54/", linkdinURL: "https://www.linkedin.com/in/arihantjain54/"),
      Developer(name: "Ayush", domain: "Android", imageURL: "https://i.ibb.co/F3wh15X/Whats-App-Image-2020-02-22-at-11-50-02-PM.jpg", post: "Category Head", instaURL: "https://www.instagram.com/ayush.m.s.1_9/", linkdinURL: "https://www.linkedin.com/in/ayush-srivastava19777"),
      Developer(name: "Rohit", domain: "iOS", imageURL: "https://i.ibb.co/zhg3zqW/Whats-App-Image-2020-02-22-at-12-02-57-AM.jpg", post: "Organiser", instaURL: "https://www.instagram.com/rohitkuber/", linkdinURL: "https://www.linkedin.com/in/rohit-kuber-b55280164/"),
      Developer(name: "Tushar", domain: "iOS", imageURL: "https://i.ibb.co/wQMTFcy/Whats-App-Image-2020-02-21-at-5-31-37-PM.jpg", post: "Organiser", instaURL: "https://www.instagram.com/tushar_tapadia/", linkdinURL: "https://www.linkedin.com/in/tushar-tapadia"),
      Developer(name: "Chakshu", domain: "Android", imageURL: "https://i.ibb.co/7j6BhXL/ch.jpg", post: "Organiser", instaURL: "https://www.instagram.com/chakshusaraswat/", linkdinURL: "https://www.linkedin.com/in/chakshu-saraswat-836160171/"),
      Developer(name: "Anant", domain: "Android", imageURL: "https://i.ibb.co/rxgN4qx/Whats-App-Image-2020-02-21-at-5-31-30-PM.jpg", post: "Organiser", instaURL: "https://www.instagram.com/infinite_verma/", linkdinURL: "https://www.linkedin.com/in/anant-verma/"),
      Developer(name: "Hardik", domain: "Android", imageURL: "https://i.ibb.co/PgfJXWL/Whats-App-Image-2020-02-21-at-6-17-49-PM.jpg", post: "Organiser", instaURL: "https://www.instagram.com/hardik.bharunt/", linkdinURL: "https://www.linkedin.com/in/hardik-bharunt/")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
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
    
    func setupView(){
        navigationItem.title = "Developers"
        collectionView.dataSource = self
        collectionView.delegate = self
        self.collectionView.backgroundColor = UIColor.CustomColors.Black.background
        self.collectionView.register(AboutCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    @objc func popViewController() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return developersData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIViewController().isSmalliPhone(){
            return CGSize(width: (view.frame.width/2)-24, height: 254)
        }
        return CGSize(width: (view.frame.width/2)-24, height: 294)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! AboutCollectionViewCell
        cell.developerViewController = self
        let dev = developersData[indexPath.row]
        let url = NSURL(string: dev.imageURL)
        cell.imageView.sd_setImage(with: url! as URL, placeholderImage:nil)
        cell.titleLabel.text = dev.name
        cell.postLabel.text = dev.post
        cell.platformLabel.text = dev.domain
        return cell
    }
    
        func openInstragram(cell: UICollectionViewCell){
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        print(developersData[indexPath.item].name)
        let appURL = URL(string: developersData[indexPath.item].instaURL)
            let webURL = developersData[indexPath.item].instaURL
        let application = UIApplication.shared
        if application.canOpenURL(appURL as! URL) {
            application.open(appURL as! URL)
        }else{
            homeViewController?.openURL(url: webURL)
            }
    }
            
            
        func openLinkedIn(cell: UICollectionViewCell){
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        print(developersData[indexPath.item].name)
        let appURL = URL(string: developersData[indexPath.item].linkdinURL)
        let webURL = developersData[indexPath.item].linkdinURL
        let application = UIApplication.shared
        if application.canOpenURL(appURL as! URL) {
            application.open(appURL as! URL)
            }else{
                homeViewController?.openURL(url: webURL)
                }
    }
        func openURL(url: String){
            guard let url = URL(string: url) else { return }
        let svc = SFSafariViewController(url: url)
        svc.preferredBarTintColor = .black
        svc.preferredControlTintColor = .white
        present(svc, animated: true, completion: nil)
    }
}
    
class AboutCollectionViewCell: UICollectionViewCell {
    
    var developerViewController: DeveloperViewController?
    
    lazy var spinnerView : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
        
        let imageView: UIImageView = {
            let iv = UIImageView()
            iv.image = UIImage(named: "placeholder")
            iv.contentMode = .scaleAspectFill
            iv.layer.masksToBounds = true
            iv.translatesAutoresizingMaskIntoConstraints = false
            iv.clipsToBounds = true
            return iv
        }()
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.textColor = .white
            label.font = UIFont.boldSystemFont(ofSize: 18)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            return label
        }()
        
        let postLabel: UILabel = {
            let label = UILabel()
            label.textColor = .lightGray
            label.font = UIFont.systemFont(ofSize: 15)
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let platformLabel: UILabel = {
            let label = UILabel()
            label.textColor = .gray
            label.font = UIFont.boldSystemFont(ofSize: 13)
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    lazy var instaButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "instagram"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.backgroundColor = .white
        button.startAnimatingPressActions()
        button.tag = 1
        button.addTarget(self, action: #selector(clickedButton(button:)), for: .touchUpInside)
        button.layer.cornerRadius = 10
        return button
    }()
    
    lazy var facebookButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "linkedin"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.backgroundColor = .white
        button.startAnimatingPressActions()
        button.tag = 0
        button.addTarget(self, action: #selector(clickedButton(button:)), for: .touchUpInside)
        button.layer.cornerRadius = 10
        return button
    }()
    
    @objc func clickedButton(button: UIButton){
        if button.tag == 0 {
            print("helo")
            developerViewController?.openLinkedIn(cell: self)
        }else{
            developerViewController?.openInstragram(cell: self)
        }
    }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupViews()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    
        func setupViews() {
            
            if UIViewController().isSmalliPhone(){
                facebookButton.layer.cornerRadius = 8
                instaButton.layer.cornerRadius = 8
                facebookButton.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
                instaButton.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
            }
            
            addSubview(imageView)
            addSubview(titleLabel)
            addSubview(postLabel)
            addSubview(platformLabel)
            addSubview(instaButton)
            addSubview(facebookButton)
            imageView.addSubview(spinnerView)
            
            self.backgroundColor = UIColor.CustomColors.Black.card
            self.layer.masksToBounds = true
            self.layer.cornerRadius = 10
            
            let width = (frame.width - 80)/2
            
            imageView.layer.cornerRadius = (frame.width-64)/2
            _ = imageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 16, leftConstant: 32, bottomConstant: 8, rightConstant: 32, widthConstant: frame.width-64, heightConstant: frame.width-64)
            _ = titleLabel.anchor(top: imageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
            _ = postLabel.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 4, leftConstant: 16, bottomConstant: 6, rightConstant: 16, widthConstant: 0, heightConstant: 0)
            _ = platformLabel.anchor(top: postLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 16, bottomConstant: 16, rightConstant: 16, widthConstant: 0, heightConstant: 0)
            _ = instaButton.anchor(top: platformLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 16, leftConstant: 32, bottomConstant: 16, rightConstant: 0, widthConstant: width, heightConstant: width)
            _ = facebookButton.anchor(top: platformLabel.bottomAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 16, rightConstant: 32, widthConstant: width, heightConstant: width)
            spinnerView.fillSuperview()
        }
}


