//
//  DescriptionTableViewCell.swift
//  Revels-20
//
//  Created by Naman Jain on 31/01/20.
//  Copyright © 2020 Naman Jain. All rights reserved.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell{
    
    var homeViewController: HomeViewController?
    
    lazy var facebookButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "facebook"), for: .normal)
        if UIViewController().isSmalliPhone(){
            button.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        }else{
            button.imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        }
        button.backgroundColor = .white
        button.startAnimatingPressActions()
        button.tag = 0
        button.addTarget(self, action: #selector(handleSocial(button:)), for: .touchUpInside)
        button.layer.cornerRadius = 10
        return button
    }()
    
    lazy var instaButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "instagram"), for: .normal)
        if UIViewController().isSmalliPhone(){
            button.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        }else{
            button.imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        }
        button.backgroundColor = .white
        button.startAnimatingPressActions()
        button.tag = 1
        button.addTarget(self, action: #selector(handleSocial(button:)), for: .touchUpInside)
        button.layer.cornerRadius = 10
        return button
    }()
    
    lazy var snapchatButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "snapchat"), for: .normal)
        if UIViewController().isSmalliPhone(){
            button.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        }else{
            button.imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        }
        button.backgroundColor = .white
        button.startAnimatingPressActions()
        button.tag = 2
        button.addTarget(self, action: #selector(handleSocial(button:)), for: .touchUpInside)
        button.layer.cornerRadius = 10
        return button
    }()
    
    lazy var twitterButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "twitter"), for: .normal)
        if UIViewController().isSmalliPhone(){
            button.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        }else{
            button.imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        }
        button.backgroundColor = .white
        button.startAnimatingPressActions()
        button.tag = 3
        button.addTarget(self, action: #selector(handleSocial(button:)), for: .touchUpInside)
        button.layer.cornerRadius = 10
        return button
    }()
    
    lazy var youtubeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "youtube"), for: .normal)
        if UIViewController().isSmalliPhone(){
            button.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        }else{
            button.imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        }
        button.backgroundColor = .white
        button.startAnimatingPressActions()
        button.tag = 4
        button.addTarget(self, action: #selector(handleSocial(button:)), for: .touchUpInside)
        button.layer.cornerRadius = 10
        return button
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = """
                    \nThe world as we know today is not what it used to be and is no more than a shadow cast in the dim blue lights from screens, barely a semblance to the lush green of the forests and icy blue of the mountain tops that it should have been. With every new day comes a report of yet another catastrophe and we find ourselves wondering, have we run out of time?\n

                    Have we gone too far to turn back? And yet it is amidst disaster that another feeling arises, of hope, of a chance at rebuilding the world, a chance at making it a world apart. With this hope in our hearts we present to you the theme for Revels '20, Qainaat : A World Apart.\n

                    Revels is a national level cultural and sports fest from Manipal Institute of Technology that aims to unite a crowd that is diverse in more ways than one. An arena for holistic learning and a chance to express thoughts and ideas through art, music, dance, drama, sports and numerous other events.\n\n
                    """
        label.textColor = .lightGray
        label.textAlignment = .center
        if UIViewController().isSmalliPhone(){
            label.font = UIFont.systemFont(ofSize: 13)
        }else{
            label.font = UIFont.systemFont(ofSize: 15)
        }
        
        label.numberOfLines = 0
        return label
    }()
    
    lazy var loveLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 22)
        let colors = [#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1), #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), #colorLiteral(red: 1, green: 0.2458487717, blue: 0.233889676, alpha: 1), #colorLiteral(red: 1, green: 0.6534388866, blue: 0.8889523104, alpha: 1), #colorLiteral(red: 1, green: 0.9230399603, blue: 0.2747652678, alpha: 1), #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)]
        let int = Int.random(in: 0 ..< colors.count)
        let text = "♥" //"Developed with ♥ by Naman Jain"
        let linkTextWithColor = "♥"
        let range = (text as NSString).range(of: linkTextWithColor)
        let attributedString = NSMutableAttributedString(string:text)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: colors[int], range: range)
        label.attributedText = attributedString
        
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var creditsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        let attributedString = NSMutableAttributedString(string: "Designed and Developed by the\nApp Dev Team at Revels’20")
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 3 // Whatever line spacing you want in points
        
        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        // *** Set Attributed String to your label ***
        label.attributedText = attributedString
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo_dark-1")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let curveImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "curve")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0.08
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var qainaatImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "logobg")
        iv.contentMode = .scaleAspectFill
        iv.alpha = 0.095
        return iv
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        let wid = UIViewController().view.frame.width
        let dim = (wid-96)/5
        
        addSubview(qainaatImageView)
        addSubview(facebookButton)
        _ = facebookButton.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: dim, heightConstant: dim)
        
        addSubview(instaButton)
        _ = instaButton.anchor(top: topAnchor, left: facebookButton.rightAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: dim, heightConstant: dim)

        addSubview(snapchatButton)
        _ = snapchatButton.anchor(top: topAnchor, left: instaButton.rightAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: dim, heightConstant: dim)

        addSubview(twitterButton)
        _ = twitterButton.anchor(top: topAnchor, left: snapchatButton.rightAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: dim, heightConstant: dim)

        addSubview(youtubeButton)
        _ = youtubeButton.anchor(top: topAnchor, left: twitterButton.rightAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: dim, heightConstant: dim)
        
//        addSubview(curveImageView)
//        _ = curveImageView.anchor(top: youtubeButton.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 48, leftConstant: 0, bottomConstant: -32, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        addSubview(descriptionLabel)
        _ = descriptionLabel.anchor(top: facebookButton.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 18, widthConstant: 0, heightConstant: 0)
        addSubview(profileImageView)
        _ = profileImageView.anchor(top: descriptionLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: -16, leftConstant: 32, bottomConstant: 16, rightConstant: 32, widthConstant: 0, heightConstant: 150)
        addSubview(creditsLabel)
        _ = creditsLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 32, leftConstant: 16, bottomConstant: 32, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        
        addSubview(loveLabel)
        _ = loveLabel.anchor(top: bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 50, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 20)
        
//        let lightGrayView = UIView()
//        lightGrayView.backgroundColor = UIColor(white: 1, alpha: 0.08)
//        addSubview(lightGrayView)
//        _ = lightGrayView.anchor(top: curveImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 500)
        
        _ = qainaatImageView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: -100, rightConstant: -120, widthConstant: 0, heightConstant: 450)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleSocial(button: UIButton){
        switch button.tag {
        case 0:
            let username =  "mitrevels"
            let appURL = URL(string: "fb://profile/103909866349788")!
            let webURL = NSURL(string: "https://www.facebook.com/\(username)")!
            let application = UIApplication.shared
            if application.canOpenURL(appURL as URL) {
                application.open(appURL as URL)
            } else {
                homeViewController?.openURL(url: "\(webURL)")
            }
            break
        case 1:
            let username = "revelsmit"
            let appURL = NSURL(string: "instagram://user?username=\(username)")!
            let webURL = NSURL(string: "https://instagram.com/\(username)")!
            let application = UIApplication.shared
            if application.canOpenURL(appURL as URL) {
                application.open(appURL as URL)
            } else {
                homeViewController?.openURL(url: "\(webURL)")
            }
            break
        case 2:
            let username =  "revelsmit"
            let appURL = NSURL(string: "snapchat://add/\(username)")!
            let webURL = NSURL(string: "https://snapchat.com/add/\(username)")!
            let application = UIApplication.shared
            if application.canOpenURL(appURL as URL) {
                application.open(appURL as URL)
            } else {
                homeViewController?.openURL(url: "\(webURL)")
            }
            break
        case 3:
            let username =  "revelsmit"
            let appURL = NSURL(string: "twitter://user?screen_name=\(username)")!
            let webURL = NSURL(string: "https://twitter.com/\(username)")!
            let application = UIApplication.shared
            if application.canOpenURL(appURL as URL) {
                application.open(appURL as URL)
            } else {
                homeViewController?.openURL(url: "\(webURL)")
            }
            break
        case 4:
            let id = "UC9gwWd47a0q042qwEgutjWw"
            let appURL = NSURL(string: "youtube://www.youtube.com/channel/\(id)")!
            let webURL = NSURL(string: "https://www.youtube.com/channel/\(id)")!
            let application = UIApplication.shared
            if application.canOpenURL(appURL as URL) {
                application.open(appURL as URL)
            } else {
                homeViewController?.openURL(url: "\(webURL)")
            }
            break
        default:
            break
        }
    }
}

