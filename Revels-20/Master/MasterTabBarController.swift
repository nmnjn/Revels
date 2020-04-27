//
//  MasterTabBarController.swift
//  TechTetva-19
//
//  Created by Naman Jain on 25/08/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit

class MasterTabBarController: UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupTabs()
    }
    
    @objc func handleMapsTap(){
        self.selectedIndex = 2
    }
    
    fileprivate func setupTabs(){
        
        let homeViewController = HomeViewController()
        let homeViewNavController = MasterNavigationBarController(rootViewController: homeViewController)
        homeViewNavController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "home"), tag: 0)
        
        let categoriesPageController = CategoriesTableViewController()
        let categoriesNavigationViewController = MasterNavigationBarController(rootViewController: categoriesPageController)
        categoriesNavigationViewController.tabBarItem = UITabBarItem(title: "Categories", image: UIImage(named: "category"), tag: 1)
        
        let mapViewController = MapViewController()
        mapViewController.tabBarItem = UITabBarItem(title: "Maps", image: UIImage(named: "loc"), tag: 2)
        
        let usersViewController = UsersViewController()
        let usersViewNavigationController = MasterNavigationBarController(rootViewController: usersViewController)
        usersViewNavigationController.tabBarItem = UITabBarItem(title: "User", image: UIImage(named: "user"), tag: 3)
        
        let schedulePageController = ScheduleController(collectionViewLayout: UICollectionViewFlowLayout())
        let schedulePageNavigationController = MasterNavigationBarController(rootViewController: schedulePageController)
        schedulePageNavigationController.tabBarItem = UITabBarItem(title: "Schedule", image: UIImage(named: "time"), tag: 4)
        
        let resultsViewController = ResultsViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let resultsNavigationController = MasterNavigationBarController(rootViewController: resultsViewController)
        resultsNavigationController.tabBarItem = UITabBarItem(title: "Results", image: UIImage(named: "assessment"), tag: 5)
        
        viewControllers = [homeViewNavController, schedulePageNavigationController, mapViewController, usersViewNavigationController, resultsNavigationController]
        
    }
    
    fileprivate func setupLayout(){
        tabBar.isTranslucent = false
        tabBar.barTintColor = UIColor.CustomColors.Black.background
        tabBar.tintColor = UIColor.CustomColors.Blue.accent
    }
}
