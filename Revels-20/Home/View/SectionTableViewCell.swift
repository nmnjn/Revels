//
//  SectionTableViewCell.swift
//  Revels-20
//
//  Created by Naman Jain on 05/02/20.
//  Copyright © 2020 Naman Jain. All rights reserved.
//

import UIKit

class SectionTableViewCell: UITableViewCell{
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.mainImageView.backgroundColor = selected ? UIColor.CustomColors.Black.card : UIColor.CustomColors.Black.card
//        self.backgroundColor = selected ? .darkGray : .clear
//        self.backgroundCard.backgroundColor = selected ? UIColor.CustomColors.Black.card : UIColor.CustomColors.Black.card
        self.seperatorLine.backgroundColor = selected ? .darkGray : .darkGray
    }
    
    lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.CustomColors.Black.card
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    lazy var seperatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .white
        return titleLabel
    }()
    
    lazy var subTitleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .lightGray
        return titleLabel
    }()
    
    lazy var subSubTitleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .darkGray
        return titleLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        let customColorView = UIView()
        customColorView.backgroundColor = .init(white: 0.2, alpha: 1)
        self.selectedBackgroundView = customColorView
        addSubview(mainImageView)
        addSubview(seperatorLine)
        if UIViewController().isSmalliPhone(){
            _ = mainImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 16, leftConstant: 16, bottomConstant: 8, rightConstant: 0, widthConstant: 70-24, heightConstant: 0)
            subTitleLabel.font = UIFont.systemFont(ofSize: 12)
            titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
            _ = seperatorLine.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 86, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.7)
        }else{
            _ = mainImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 16, leftConstant: 16, bottomConstant: 8, rightConstant: 0, widthConstant: 100-24, heightConstant: 0)
            _ = seperatorLine.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 116, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.7)
        }

        addSubview(subTitleLabel)
        subTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 11).isActive = true
        subTitleLabel.leftAnchor.constraint(equalTo: mainImageView.rightAnchor, constant: 16).isActive = true
        subTitleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        
        addSubview(titleLabel)
        titleLabel.bottomAnchor.constraint(equalTo: subTitleLabel.topAnchor, constant: -4).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: mainImageView.rightAnchor, constant: 16).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 16).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
