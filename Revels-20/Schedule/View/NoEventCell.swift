//
//  NoEventCell.swift
//  TechTetva-19
//
//  Created by Naman Jain on 01/09/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit

class NoEventCell: UITableViewCell{

    
    lazy var emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "noEvent")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "no events on this day"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    fileprivate func setupLayout(){
        backgroundColor = .clear
        self.selectionStyle = .none
        self.selectedBackgroundView = UIView()
        addSubview(emptyImageView)
//        _ = emptyImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 16, leftConstant: 22, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 130)
        
        emptyImageView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 16).isActive = true
        emptyImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        emptyImageView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        emptyImageView.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
        
        addSubview(label)
        _ = label.anchorWithConstants(top: emptyImageView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 16, rightConstant: 16)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
