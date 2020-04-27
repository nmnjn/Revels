//
//  LocationSearchTableViewCell.swift
//  Revels
//
//  Created by Akhilesh Shenoy on 10/01/20.
//  Copyright © 2020 Naman Jain. All rights reserved.
//

import UIKit

class LocationSearchTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.textLabel?.textColor = .lightGray
        self.selectionStyle = .blue
        self.backgroundColor = .clear
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
