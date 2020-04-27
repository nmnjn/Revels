//
//  collegeTableViewCell.swift
//  Revels
//
//  Created by Akhilesh Shenoy on 19/02/20.
//  Copyright © 2020 Naman Jain. All rights reserved.
//

import UIKit


class noCollegeTableViewCell: UITableViewCell{
    
    lazy var informationLabel: UITextView = {
        let label = UITextView()
        label.text = "If college is not present,\nplease contact\nOutstation Management at\nom.revels20@gmail.com\nor +91 96112 38663"
        label.textColor = .lightGray
        label.backgroundColor = UIColor.CustomColors.Black.background
        label.isEditable = false
        label.dataDetectorTypes = UIDataDetectorTypes.all
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        self.addSubview(informationLabel)
        _ = informationLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 16, rightConstant: 16, widthConstant: 0, heightConstant: 200)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class collegeTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        self.textLabel?.textColor = .lightGray
        self.textLabel?.numberOfLines = 0
        self.textLabel?.lineBreakMode = .byWordWrapping
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
