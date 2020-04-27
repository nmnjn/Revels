//
//  PositionCell.swift
//  TechTetva-19
//
//  Created by Naman Jain on 26/08/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit

class PositionCell: UITableViewCell {
    
    // MARK: - Properties
    
    lazy var backgroundCardView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.CustomColors.Black.card
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var positionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 120, weight: .bold)
        label.textColor = .darkGray
        return label
    }()
    
    lazy var teamIdTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Team ID  "
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        //        label.textColor = .darkGray
        label.textColor = .white
        return label
    }()
    
    lazy var teamIdLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        //        label.textColor = .darkGray
        label.textColor = .white
        return label
    }()
    
    lazy var medalImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Functions
    
    fileprivate func setupViews(){
        addSubview(backgroundCardView)
        backgroundColor = UIColor.CustomColors.Black.background
        backgroundCardView.anchorWithConstants(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 8, leftConstant: 16, bottomConstant: 8, rightConstant: 16)
        backgroundCardView.clipsToBounds = true
        
        backgroundCardView.addSubview(positionLabel)
        _ = positionLabel.anchor(top: backgroundCardView.topAnchor, left: backgroundCardView.leftAnchor, bottom: backgroundCardView.bottomAnchor, right: backgroundCardView.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: -12, rightConstant: 16, widthConstant: 0, heightConstant: 100)
        
        backgroundCardView.addSubview(teamIdLabel)
        teamIdLabel.anchorWithConstants(top: nil, left: backgroundCardView.leftAnchor, bottom: bottomAnchor, right: backgroundCardView.rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 16, rightConstant: 16)
        
        backgroundCardView.addSubview(teamIdTitleLabel)
        teamIdTitleLabel.anchorWithConstants(top: nil, left: backgroundCardView.leftAnchor, bottom: teamIdLabel.topAnchor, right: backgroundCardView.rightAnchor, topConstant: 32, leftConstant: 16, bottomConstant: 0, rightConstant: 16)
        
        backgroundCardView.addSubview(medalImageView)
        _ = medalImageView.anchor(top: backgroundCardView.topAnchor, left: nil, bottom: nil, right: backgroundCardView.rightAnchor, topConstant: -4, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 40, heightConstant: 40)
    }
    
}

