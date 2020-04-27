//
//  MenuCell.swift
//  TechTetva-19
//
//  Created by Naman Jain on 25/08/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit

class MenuCell: UICollectionViewCell {
    
    var color: UIColor?{
        didSet {
            if isSelected{
                label.textColor = color
            }
        }
    }
    let label: UILabel = {
        let l = UILabel()
        l.text = "Menu Item"
        l.textAlignment = .center
        l.textColor = .lightGray
        l.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return l
    }()
    
    override var isSelected: Bool {
        didSet {
            label.textColor = isSelected ? color ?? .black : .lightGray
            label.font = isSelected ? UIFont.systemFont(ofSize: 16, weight: .medium) : UIFont.systemFont(ofSize: 16, weight: .regular)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        label.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
