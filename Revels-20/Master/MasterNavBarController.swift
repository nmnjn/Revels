//
//  MasterNavBarController.swift
//  TechTetva-19
//
//  Created by Naman Jain on 25/08/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit

class MasterNavigationBarController: UINavigationController {
    
    private var themedStatusBarStyle: UIStatusBarStyle?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return themedStatusBarStyle ?? UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.CustomColors.Black.background
        themedStatusBarStyle = .lightContent
        setNeedsStatusBarAppearanceUpdate()
        
        navigationBar.barTintColor = UIColor.CustomColors.Black.background
        navigationBar.tintColor = UIColor.CustomColors.Blue.accent
        
        navigationBar.isTranslucent = false
        navigationBar.shadowImage = UIImage()
        navigationBar.setValue(true, forKey: "hidesShadow")
        
        let titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        navigationBar.titleTextAttributes = titleTextAttributes
        navigationBar.largeTitleTextAttributes = titleTextAttributes
    }
}
