//
//  HomeViewController.swift
//  TechTetva-19
//
//  Created by Naman Jain on 30/09/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit
import SDWebImage
import SafariServices
import Alamofire
import MBProgressHUD

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate{
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.dataSource = self
        tv.delegate = self
        tv.showsVerticalScrollIndicator = false
        return tv
    }()
    
    var sequence = [Int]()
    var i = 0
    
    var sponsors = [SponsorsData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        testerFunction()
        getSponsors()
        let shuffledSequence = 0 ..< images.count
        sequence = shuffledSequence.shuffled()
    }
    
    func getSponsors(){
        if let spns = Caching.sharedInstance.getSponsorsFromCache(){
            self.sponsors = spns
        }else{
            let apiStruct = ApiStruct(url: sponsorsURL, method: .get, body: nil)
            WSManager.shared.getJSONResponse(apiStruct: apiStruct, success: { (spns: [SponsorsData]) in
                self.sponsors = spns
                Caching.sharedInstance.saveSponsorsToCache(sponsors: spns)
            }) { (error) in
               print(error)
            }
        }
    }
    
    @objc func showInfoOptions(){
        let thoughts = ["“The only thing we have to fear is fear itself.”", "“Darkness cannot drive out darkness; only light can do that. Hate cannot drive out hate; only love can do that.”", "“If you tell the truth, you don’t have to remember anything.”", "“Great minds discuss ideas; average minds discuss events; small minds discuss people.”", "“A person who never made a mistake never tried anything new.”", "“If you look at what you have in life, you’ll always have more. If you look at what you don’t have in life, you’ll never have enough.”" ,"“It is never too late to be what you might have been.”" ,"“You miss 100% of the shots you don’t take.”" ,"“If you want to lift yourself up, lift up someone else.”" ,"“Too many of us are not living our dreams because we are living our fears.”" ,"“Remember that happiness is a way of travel, not a destination.”" ," “Believe you can and you’re halfway there.”" ,"“Everything has beauty, but not everyone can see.”" ,"“The difference between ordinary and extraordinary is that little extra.”" ,"“Life shrinks or expands in proportion to one’s courage.”" ,"“A journey of a thousand leagues begins beneath one’s feet.”" ,"“I haven’t failed. I’ve just found 10,000 ways that won’t work.”" ,"“Strive not to be a success, but rather to be of value.”" ,"“Wise men speak because they have something to say; fools because they have to say something.”" ,"“If opportunity doesn’t knock, build a door.”" ,"“If you cannot do great things, do small things in a great way.”" ,"“Be yourself; everyone else is already taken.”" ,"“Do what you can, with what you have, where you are.”" ,"“Anyone who stops learning is old, whether at twenty or eighty. Anyone who keeps learning stays young. The greatest thing in life is to keep your mind young.”" ,"“Though no one can go back and make a brand new start, anyone can start from now and make a brand new ending.”" ,"“Self-reverence, self-knowledge, self control — these three alone lead to power.”" ,"“In three words I can sum up everything I’ve learned about life: It goes on.”" ,"“There are two ways of spreading light: to be the candle or the mirror that reflects it.”" ,"“Being deeply loved by someone gives you strength, while loving someone deeply gives you courage.”" ,"“Always forgive your enemies; nothing annoys them so much.”" ,"“Courage doesn’t always roar. Sometimes courage is the little voice at the end of the day that says ‘I’ll try again tomorrow.'”" ,"“He who angers you conquers you.”"]
        
        let suffledQoutes = thoughts.shuffled()
        DispatchQueue.main.async(execute: {
            let alertController = UIAlertController(title: suffledQoutes[0], message: nil, preferredStyle: .actionSheet)
            let developerOption = UIAlertAction(title: "👩🏻‍💻 App Developers 👨🏻‍💻", style: .default) { (_) in
                self.showDeveloper()
            }
            
            let sponsorOption = UIAlertAction(title: "💛 Give Review 🌟", style: .default) { (_) in
                guard let writeReviewURL = URL(string: "https://itunes.apple.com/app/id1500173604?action=write-review")
                    else { fatalError("Expected a valid URL") }
                UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
//                self.showSponsors()
            }
            
            let okayAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
                
            })
            
            
            alertController.addAction(developerOption)
            alertController.addAction(sponsorOption)
            alertController.addAction(okayAction)
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    fileprivate func testerFunction(){
        for image in images{
            let url = NSURL(string: image)
            SDWebImageManager.shared.loadImage(with: url! as URL, options: .continueInBackground, context: nil, progress: nil) { (_, _, _, _, _, _) in
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private var themedStatusBarStyle: UIStatusBarStyle?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return themedStatusBarStyle ?? UIStatusBarStyle.lightContent
    }
    
    func updateStatusBar(){
        themedStatusBarStyle = .lightContent
        setNeedsStatusBarAppearanceUpdate()
    }
    
    fileprivate func setupNavigationBar(){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        updateStatusBar()
    }
    
    var homeHeader: HomeHeader?
    var homeHeaderHeight: CGFloat = 200.0
    
    lazy var navigationView: UIView = {
        let view = UIView()
        view.backgroundColor =  UIColor.CustomColors.Black.background//UIColor.CustomColors.Green.register
        view.alpha = 0
        return view
    }()
    
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Revels'20"
        label.textAlignment = .center
        label.alpha = 0
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    lazy var qainaatImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "qainaat")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var liveBlogButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "blog")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.contentMode = .scaleAspectFit
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        button.addTarget(self, action: #selector(showLiveBlog), for: .touchUpInside)
        return button
    }()
    
    lazy var developersButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "info"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        button.addTarget(self, action: #selector(showInfoOptions), for: .touchUpInside)
        return button
    }()
    
    lazy var newsLetterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "del")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.contentMode = .scaleAspectFit
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        button.addTarget(self, action: #selector(showDeveloper), for: .touchUpInside)
        return button
    }()
    
    
    @objc func showLiveBlog(){
        let liveBlogVC = LiveBlogController()
        self.navigationController?.pushViewController(liveBlogVC, animated: true)
    }
    
    @objc func showDeveloper(){
        let liveBlogVC = DeveloperViewController(collectionViewLayout: UICollectionViewFlowLayout())
        self.navigationController?.pushViewController(liveBlogVC, animated: true)
    }
    
    @objc func showSponsors(){
        let sponsorsViewController = SponsorsViewController()
        sponsorsViewController.homeViewController = self
        sponsorsViewController.sponsors = self.sponsors
        self.navigationController?.pushViewController(sponsorsViewController, animated: true)
    }
    
    
    @objc func showNewsLetter(){
        let newsLetterVC = OrderPDFViewController()
        newsLetterVC.hidesBottomBarWhenPushed = true
        guard let pdfURL = UserDefaults.standard.string(forKey: "newletterurl") else { return }
        self.checkFileExists(fileName: String(pdfURL)) { (exists, filePath) in
            if exists{
                newsLetterVC.nameOfFile = String(pdfURL)
                newsLetterVC.pdfLink = filePath
                self.navigationController?.pushViewController(newsLetterVC, animated: true)
            }else{
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.mode = .annularDeterminate
                hud.label.text = "Downloading..."
                let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                    let DocumentsURL: NSURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
                    let fileURL = DocumentsURL.appendingPathComponent("\(pdfURL)")
//                                print(fileURL)
                    return (fileURL!, [.removePreviousFile, .createIntermediateDirectories])
                }

                Alamofire.download(pdfURL, to: destination).downloadProgress(closure: { (prog) in
//                    print(prog)
                    hud.progress = Float(prog.fractionCompleted)
                }).response { (response) in
                    hud.hide(animated: true)
                    if response.error == nil, let filePath = response.destinationURL?.path{
                        if response.response?.statusCode != 200{
                            print("DELETE THIS FILE FROM \(filePath)")
                            self.deleteFile(filePath: filePath)
                        }else{
                            print("Downloaded Successfully at \(filePath)")
                            newsLetterVC.nameOfFile = String(pdfURL)
                            newsLetterVC.pdfLink = filePath//pdfLink.replacingOccurrences(of: " ", with: "%20")
                            self.navigationController?.pushViewController(newsLetterVC, animated: true)
                        }
                    }else{
                        print("*********** ERROROR *********")
                        print(response)
                        return
                    }
                }
            }
        }
//        self.navigationController?.pushViewController(newsLetterVC, animated: true)
    }
    
    func checkFileExists(fileName: String, completion: (_ exists: Bool, _ filePath: String)->()){
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent("\(fileName)") {
            
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                print("FILE AVAILABLE")
                completion(true, filePath)
            } else {
                completion(false, filePath)
                print("FILE NOT AVAILABLE")
            }
        } else {
            print("FILE PATH NOT AVAILABLE")
        }
    }
    
    func deleteFile(filePath: String){
        do {
            let fileManager = FileManager.default
            try fileManager.removeItem(atPath: filePath)
            print("file deleted success")
        } catch _ {
            print("coudn't delete")
        }
    }
    
    @objc func handleTap(){
        self.updateHeaderImage()
    }
    
    fileprivate func setupTableView(){
        view.addSubview(tableView)
        tableView.fillSuperview()
        
        tableView.backgroundColor = UIColor.CustomColors.Black.background
        tableView.separatorStyle = .none
        tableView.register(HeaderTableViewCell.self, forCellReuseIdentifier: "HeaderTableViewCell")
        tableView.register(SectionTableViewCell.self, forCellReuseIdentifier: "SectionTableViewCell")
        tableView.register(DescriptionTableViewCell.self, forCellReuseIdentifier: "DescriptionTableViewCell")
        tableView.register(MITPostTableViewCell.self, forCellReuseIdentifier: "MITPostTableViewCell")
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)
        homeHeader = HomeHeader(frame: frame)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapRecognizer.delegate = self
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        homeHeader?.addGestureRecognizer(tapRecognizer)
        tableView.addSubview(homeHeader!)
//        tableView.tableHeaderView = homeHeader
        tableView.contentInset = UIEdgeInsets(top: homeHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -homeHeaderHeight - 8)
        tableView.tableFooterView = UIView()
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
        
        homeHeader?.headerImageView.image = UIImage(named: "placeholder")
        
        let widhtConstant = 40
        
        if UIDevice.current.hasNotch {
            view.addSubview(navigationView)
            _ = navigationView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 90)
        } else {
            view.addSubview(navigationView)
            _ = navigationView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 64)
        }
        view.addSubview(developersButton)
        if isSmalliPhone(){
            
            _ = developersButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 4 , leftConstant: 0, bottomConstant: 0, rightConstant: 16, widthConstant: 25, heightConstant: 25)
        }else{
            _ = developersButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 4 , leftConstant: 0, bottomConstant: 0, rightConstant: 16, widthConstant: 30, heightConstant: 30)
        }

        
//        view.addSubview(newsLetterButton)
//        _ = newsLetterButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: navigationView.bottomAnchor, right: liveBlogButton.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: CGFloat(widhtConstant), heightConstant: 0)
    
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(tableView.contentOffset.y)
        var headerRect = CGRect(x: 0, y: -homeHeaderHeight, width: tableView.bounds.width, height: homeHeaderHeight)
        if tableView.contentOffset.y < -homeHeaderHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
         }
        var offset = (tableView.contentOffset.y + 120) / 30
        if offset < 0{
            offset = 0
        }
        
        if offset > 1{
            offset = 1
            navigationView.alpha = offset
            titleLabel.alpha = offset
        }else{
            navigationView.alpha = 0
            titleLabel.alpha = 0
        }
        homeHeader?.headerImageView.alpha = 1 - offset
//        homeHeader?.gradient.frame = headerRect
        homeHeader?.frame = headerRect
//        homeHeader?.gradient.frame.size.height = headerRect.size.height
        homeHeader?.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateHeaderImage()
    }
    
    func updateHeaderImage(){
        guard let view = homeHeader?.headerImageView else { return }
        UIView.transition(with: view,
        duration: 0.3,
        options: .transitionCrossDissolve,
        animations: {
            let url = NSURL(string: images[self.sequence[self.i]])
            self.i = (self.i + 1) % images.count
            view.sd_setImage(with: url! as URL, placeholderImage: UIImage(named: "placeholder"))
            print(url!)
        })
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 6{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionTableViewCell") as! DescriptionTableViewCell
            cell.homeViewController = self
            cell.selectionStyle = .none
            return cell
            
        }else if indexPath.row == 5{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MITPostTableViewCell") as! MITPostTableViewCell
            cell.homeViewController = self
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionTableViewCell") as! SectionTableViewCell
            cell.accessoryType = .disclosureIndicator
            switch indexPath.row {
            case 0:
                cell.titleLabel.text = "Categories"
                cell.subTitleLabel.text = "Curated just for you"
                cell.subSubTitleLabel.text = ""
                cell.mainImageView.image = UIImage(named: "cat")
                break
            case 1:
                cell.titleLabel.text = "Events"
                cell.subTitleLabel.text = "Filtered by Genre"
                cell.subSubTitleLabel.text = ""
                cell.mainImageView.image = UIImage(named: "del")
            case 2:
                cell.titleLabel.text = "Proshow"
                cell.subTitleLabel.text = "Ground Zero"
                cell.subSubTitleLabel.text = ""
                cell.mainImageView.image = UIImage(named: "blog")
                break
            case 3:
                cell.titleLabel.text = "Featured Events"
                cell.subTitleLabel.text = "Win Big Cash Prizes"
                cell.subSubTitleLabel.text = ""
                cell.mainImageView.image = UIImage(named: "featured")
                break
            case 4:
                cell.titleLabel.text = "Sponsors"
                cell.subTitleLabel.text = "Our Proud Partners"
                cell.subSubTitleLabel.text = ""
                cell.mainImageView.image = UIImage(named: "sponsors")
                cell.seperatorLine.alpha = 0
                break
            default: break
            }
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
            case 6:
                return UITableView.automaticDimension
            default:
                if isSmalliPhone(){
                    return 70
                }
                return 100
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let categoriesPageController = CategoriesTableViewController()
            self.navigationController?.pushViewController(categoriesPageController, animated: true)
            break
        case 1:
            let tagsEventsController = TagsEventsViewController()
            self.navigationController?.pushViewController(tagsEventsController, animated: true)
            break
        case 2:
            let proshowViewController = ProshowViewController(collectionViewLayout: UICollectionViewFlowLayout())
            self.navigationController?.pushViewController(proshowViewController, animated: true)
            break
        case 3:
            let featuredViewController = FeaturedEventsConroller()
            self.navigationController?.pushViewController(featuredViewController, animated: true)
            break
        case 4:
            let sponsorsViewController = SponsorsViewController()
            sponsorsViewController.homeViewController = self
            sponsorsViewController.sponsors = self.sponsors
            self.navigationController?.pushViewController(sponsorsViewController, animated: true)
            break
        default:
            break
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

class HeaderTableViewCell: UITableViewCell{
    
    lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.CustomColors.Black.card
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        let titleLabel = UILabel()
        titleLabel.text = "Revels'20"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        
        let subTitleLabel = UILabel()
        subTitleLabel.text = "Qainaat - A World Apart"
        subTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        subTitleLabel.textColor = .white
        subTitleLabel.sizeToFit()
        
        addSubview(mainImageView)
        mainImageView.fillSuperview(padding: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        
        let gradient: CAGradientLayer = CAGradientLayer()
        if UIViewController().isSmalliPhone(){
           gradient.frame = CGRect(x: 0, y: 0, width: frame.width + 100, height: 180)
        }else{
            gradient.frame = CGRect(x: 0, y: 0, width: frame.width + 100, height: 230)
        }
        gradient.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.init(white: 0, alpha: 0.9).cgColor]
        gradient.locations = [0.0, 0.4, 0.95]
        mainImageView.layer.insertSublayer(gradient, at: 0)
        
        mainImageView.addSubview(subTitleLabel)
        subTitleLabel.anchorWithConstants(top: nil, left: mainImageView.leftAnchor, bottom: mainImageView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 16, bottomConstant: 16, rightConstant: 16)
        
        mainImageView.addSubview(titleLabel)
        titleLabel.anchorWithConstants(top: nil, left: mainImageView.leftAnchor, bottom: subTitleLabel.topAnchor, right: nil, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 16)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class HomeHeader: UIView, UIGestureRecognizerDelegate{
    
    // MARK: - Properties
    
    lazy var headerImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "placeholder")
        return iv
    }()
    
    
    let gradient: CAGradientLayer = CAGradientLayer()
    let gradientMaskLayer = CAGradientLayer()
    let view = UIView()
    
    override func layoutSubviews() {
        gradientMaskLayer.frame = .init(x: 0, y: 0, width: bounds.width, height: view.bounds.height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let titleLabel = UILabel()
        titleLabel.text = "Revels'20"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        
        let subTitleLabel = UILabel()
        subTitleLabel.text = "Qainaat - A World Apart"
        subTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        subTitleLabel.textColor = .white
        subTitleLabel.sizeToFit()
        
        addSubview(headerImageView)
        _ = headerImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
        view.backgroundColor = .clear
        
        gradientMaskLayer.colors = [UIColor.clear.cgColor, UIColor.CustomColors.Black.background.cgColor]
        gradientMaskLayer.locations = [0, 1]
        
        view.layer.addSublayer(gradientMaskLayer)
        headerImageView.addSubview(view)
        
        
        headerImageView.addSubview(subTitleLabel)
        subTitleLabel.anchorWithConstants(top: nil, left: headerImageView.leftAnchor, bottom: headerImageView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 16, bottomConstant: 16, rightConstant: 16)
        
        headerImageView.addSubview(titleLabel)
        titleLabel.anchorWithConstants(top: nil, left: headerImageView.leftAnchor, bottom: subTitleLabel.topAnchor, right: nil, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 16)
        
        view.anchorWithConstants(top: titleLabel.topAnchor, left: headerImageView.leftAnchor, bottom: headerImageView.bottomAnchor, right: headerImageView.rightAnchor, topConstant: -48, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        
//        view.anchorWithConstants(top: titleLabel.topAnchor, left: headerImageView.leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 16)
        
    }
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
