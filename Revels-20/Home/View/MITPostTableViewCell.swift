//
//  MITPostTableViewCell.swift
//  Revels-20
//
//  Created by Naman Jain on 05/02/20.
//  Copyright © 2020 Naman Jain. All rights reserved.
//

import UIKit


class MITPostTableViewCell: UITableViewCell{
    
    var homeViewController: HomeViewController?
    
    lazy var liveBlogButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "liveblog")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.contentMode = .scaleAspectFit
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .lightGray
        button.backgroundColor = UIColor.CustomColors.Black.card
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(showLiveBlog), for: .touchUpInside)
        return button
    }()
    
    lazy var newsLetterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "newsletter")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.contentMode = .scaleAspectFit
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .lightGray
        button.backgroundColor = UIColor.CustomColors.Black.card
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(showNewsLetter), for: .touchUpInside)
        return button
    }()
    
    
    @objc func showLiveBlog(){
        self.homeViewController?.showLiveBlog()
    }
    
    @objc func showNewsLetter(){
        self.homeViewController?.showNewsLetter()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        addSubview(newsLetterButton)
//        let width = (frame.width) / 2
        _ = newsLetterButton.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 16, leftConstant: 16, bottomConstant: 8, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        newsLetterButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45).isActive = true
        
        addSubview(liveBlogButton)
        _ = liveBlogButton.anchor(top: topAnchor, left: newsLetterButton.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 8, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.text = "Newsletter"
        
        let titleLabel1 = UILabel()
        titleLabel1.numberOfLines = 0
        titleLabel1.translatesAutoresizingMaskIntoConstraints = false
        titleLabel1.textColor = .white
        titleLabel1.textAlignment = .center
        titleLabel1.text = "Live Blog"
        
        if UIViewController().isSmalliPhone(){
            titleLabel.font = UIFont.boldSystemFont(ofSize: 10)
            titleLabel1.font = UIFont.boldSystemFont(ofSize: 10)
            
            newsLetterButton.addSubview(titleLabel)
            _ = titleLabel.anchor(top: nil, left: newsLetterButton.leftAnchor, bottom: newsLetterButton.bottomAnchor, right: newsLetterButton.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 4, rightConstant: 0, widthConstant: 0, heightConstant: 14)
            
            liveBlogButton.addSubview(titleLabel1)
            titleLabel1.anchor(top: nil, left: liveBlogButton.leftAnchor, bottom: liveBlogButton.bottomAnchor, right: liveBlogButton.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 4, rightConstant: 0, widthConstant: 0, heightConstant: 14)
            
            newsLetterButton.imageEdgeInsets = .init(top: 8, left: 0, bottom: 18, right: 0)
            liveBlogButton.imageEdgeInsets = .init(top: 8, left: 0, bottom: 18, right: 0)
        }else{
            titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
            titleLabel1.font = UIFont.boldSystemFont(ofSize: 14)
            
            newsLetterButton.addSubview(titleLabel)
            _ = titleLabel.anchor(top: nil, left: newsLetterButton.leftAnchor, bottom: newsLetterButton.bottomAnchor, right: newsLetterButton.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 8, rightConstant: 0, widthConstant: 0, heightConstant: 16)
            
            liveBlogButton.addSubview(titleLabel1)
            _ = titleLabel1.anchor(top: nil, left: liveBlogButton.leftAnchor, bottom: liveBlogButton.bottomAnchor, right: liveBlogButton.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 8, rightConstant: 0, widthConstant: 0, heightConstant: 16)
            
            newsLetterButton.imageEdgeInsets = .init(top: 16, left: 0, bottom: 32, right: 0)
            liveBlogButton.imageEdgeInsets = .init(top: 16, left: 0, bottom: 32, right: 0)
        }
        
        

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
