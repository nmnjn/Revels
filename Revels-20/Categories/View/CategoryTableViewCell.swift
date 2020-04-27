//
//  CategoryTableViewCell.swift
//  TechTetva-19
//
//  Created by Vedant Jain on 26/08/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.backgroundCard.backgroundColor = selected ? UIColor.CustomColors.Black.card : UIColor.CustomColors.Black.card
        self.separatorView.backgroundColor = selected ? UIColor.CustomColors.Blue.accent : UIColor.CustomColors.Blue.accent
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
    
    let circleView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(white: 1, alpha: 0.06)
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.CustomColors.Blue.accent
        return view
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    //MARK: - Setup
    
    func setupLayout(){
        
        if UIViewController().isSmalliPhone(){
            self.titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
            self.descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        }
        
        addSubview(backgroundCard)
        self.backgroundColor = .clear
        self.selectedBackgroundView = UIView()
        
        addSubview(titleLabel)
        _ = titleLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 0)
        addSubview(separatorView)
        _ = separatorView.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 1)
        addSubview(descriptionLabel)
        _ = descriptionLabel.anchor(top: separatorView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 8, leftConstant: 32, bottomConstant: 24, rightConstant: 32, widthConstant: 0, heightConstant: 0)

        _ = backgroundCard.anchor(top: titleLabel.topAnchor, left: leftAnchor, bottom: descriptionLabel.bottomAnchor, right: rightAnchor, topConstant: -8, leftConstant: 16, bottomConstant: -8, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        
        
        backgroundCard.addSubview(circleView)
        circleView.leadingAnchor.constraint(equalTo: backgroundCard.leadingAnchor, constant: -200).isActive = true
        circleView.topAnchor.constraint(equalTo: backgroundCard.topAnchor, constant: -250).isActive = true
        circleView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        circleView.widthAnchor.constraint(equalToConstant: 400).isActive = true
        circleView.layer.cornerRadius = 200
    }
}

