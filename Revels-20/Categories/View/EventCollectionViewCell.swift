//
//  EventCollectionViewCell.swift
//  TechTetva-19
//
//  Created by Vedant Jain on 26/08/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.CustomColors.Black.background
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let backgroundCard: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.CustomColors.Black.card
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Event"
        return label
    }()
    
    fileprivate func setupBackgroundCard() {
        self.addSubview(backgroundCard)
        backgroundCard.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundCard.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        backgroundCard.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        backgroundCard.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    fileprivate func setupTitleLabel() {
        self.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    func setupViews() {
        setupBackgroundCard()
        setupTitleLabel()
    }
    
}

