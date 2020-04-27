//
//  ResetPassword.swift
//  TechTetva-19
//
//  Created by Naman Jain on 27/09/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import Foundation
import UIKit
import BLTNBoard
import Alamofire

extension AppDelegate{
    
    func makePasswordTextFieldPage() -> TextFieldBulletinPage {
        
        let page = TextFieldBulletinPage(title: "Reset Password")
        page.placeholderText = "Password"
        page.secureTextField = true
        page.isDismissable = true
        page.requiresCloseButton = false
        page.descriptionText = "To update your password, please choose a new password."
        page.actionButtonTitle = "Continue"
        
        page.textInputHandler = { (item, text) in
            if text!.count < 8 {
                page.next = self.makeLessThanEightPage()
            }else{
                page.next = self.makePasswordConfirmTextFieldPage(firstPW: text!)
            }
            item.manager?.displayNextItem()
        }
        return page
    }
    
    func makePasswordConfirmTextFieldPage(firstPW: String) -> TextFieldBulletinPage {
        
        let page = TextFieldBulletinPage(title: "Re-enter Password")
        page.placeholderText = "Repeat Password"
        page.secureTextField = true
        page.isDismissable = true
        page.requiresCloseButton = false
        page.descriptionText = "Please re-enter your new password."
        page.actionButtonTitle = "Continue"
        
        page.textInputHandler = { (item, text) in
            if firstPW == text!{
                item.manager?.displayActivityIndicator()
                guard let resetToken = self.resetPasswordToken else{
                    return
                }
                Networking.sharedInstance.resetPassword(Token: resetToken, Password: firstPW, dataCompletion: { (successMessage) in
                    print(successMessage)
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1/2), execute: {
                            page.next = self.makeCompletionPage()
                            item.manager?.displayNextItem()
                        })
                }, errorCompletion: { (errorMessage) in
                    print(errorMessage)
                    page.next = self.makeFailurePage(Message: errorMessage)
                    item.manager?.displayNextItem()
                    return
                })
            }else{
                page.next = self.makeMismatchPasswordPage()
                item.manager?.displayNextItem()
            }
        }
        return page
    }
    
    func makeLessThanEightPage() -> BLTNPageItem {
        
        let page = BLTNPageItem(title: "Uh Oh!")
        
        page.descriptionText = "The password needs to be atleast 8 characters long."
        page.actionButtonTitle = "Try Again"
//        page.alternativeButtonTitle = "Later"
        
        page.isDismissable = true
        page.requiresCloseButton = false
        
        page.actionHandler = { item in
            item.manager?.popToRootItem()
        }
        
//        page.alternativeHandler = { item in
//            item.manager?.dismissBulletin(animated: true)
//        }
        return page
    }
    
    func makeMismatchPasswordPage() -> BLTNPageItem {
        
        let page = BLTNPageItem(title: "Uh Oh!")
        
        page.descriptionText = "Your passwords do not match!"
        page.actionButtonTitle = "Try Again"
        page.alternativeButtonTitle = "Later"
        
        page.isDismissable = true
        page.requiresCloseButton = false
        
        page.actionHandler = { item in
            item.manager?.popToRootItem()
            
        }
        
        page.alternativeHandler = { item in
            item.manager?.dismissBulletin(animated: true)
        }
        return page
    }
    
    func makeFailurePage(Message: String) -> BLTNPageItem {
        
        let page = BLTNPageItem(title: "Uh Oh!")
        
        page.descriptionText = "We are unable to reset your password!\n\(Message)"
        page.actionButtonTitle = "Try in Safari"
        page.alternativeButtonTitle = "Later"
        
        page.isDismissable = true
        page.requiresCloseButton = false
        
        page.actionHandler = { item in
            item.manager?.popToRootItem()
        }
        page.alternativeHandler = { item in
            item.manager?.dismissBulletin(animated: true)
        }
        return page
    }
    
    func makeCompletionPage() -> BLTNPageItem {
        let page = BLTNPageItem(title: "Password Updated Successfully!")
        page.descriptionText = "Please login with your New Password."
        page.actionButtonTitle = "Continue"
        page.isDismissable = true
        page.requiresCloseButton = false
        page.actionHandler = { item in
            item.manager?.dismissBulletin(animated: true)
        }
        
        return page
        
    }
    
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb{
            
            
            if let url = userActivity.webpageURL?.absoluteString {
                print(url)
                if let queryItems = URLComponents(string: url)?.queryItems{
                    if let param1 = queryItems.filter({$0.name == "resetLink"}).first{
                        if let token = param1.value {
                            print(token)
                            resetPasswordToken = token
                            if let topMostViewController = UIApplication.shared.topMostViewController(){
                                if UserDefaults.standard.bool(forKey: "isLoggedIn") == false {
                                    bulletinManager.showBulletin(above: topMostViewController)
                                }
                            }
                        }
                    }
                }
            }
        }
        return true
    }
}


// user extentions to get the top most view controller.
extension UIViewController {
    func topMostViewController() -> UIViewController {
        
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        
        return self
    }
}

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController()
    }
}
