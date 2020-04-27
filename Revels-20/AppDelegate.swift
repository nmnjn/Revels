//
//  AppDelegate.swift
//
//  Created by Naman Jain on 25/08/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit
import Disk
import BLTNBoard
import Firebase
import FirebaseMessaging
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate{

    var window: UIWindow?
    
    var resetPasswordToken: String?
    var resetPasswordUrl: String?
    
    lazy var bulletinManager: BLTNItemManager = {
        return BLTNItemManager(rootItem: makePasswordTextFieldPage())
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        getEvents()
        getSchedule()
        getCategories()
        getDelegateCards()
        getNewsletterURL()
        getProshowData()
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = MasterTabBarController()
        
        FirebaseConfiguration.shared.setLoggerLevel(FirebaseLoggerLevel.min)
        FirebaseApp.configure()
        
        
        Messaging.messaging().delegate = self
        application.registerForRemoteNotifications()
        UNUserNotificationCenter.current().delegate = self
        requestNotificationAuthorization(application: application)
        
        StoreKitHelper.incrementNumberOfTImesLaunched()
        StoreKitHelper.displayRequestRatings()
        
        return true
    }

    // MARK: - Data Functions
    
    fileprivate func getDelegateCards(){
        var delegateCardsDictionary = [Int: DelegateCard]()
        Networking.sharedInstance.getData(url: delegateCardsURL, decode: DelegateCard(), dataCompletion: { (data) in
            for card in data{
                delegateCardsDictionary[card.id] = card
            }
            Caching.sharedInstance.saveDelegateCardsToCache(cards: data)
            Caching.sharedInstance.saveDelegateCardsDictionaryToCache(dict: delegateCardsDictionary)
        }) { (errorMessage) in
            print(errorMessage)
        }
    }
    
    func getNewsletterURL(){
        Networking.sharedInstance.getNewsLetterUrl(dataCompletion: { (url) in
            UserDefaults.standard.set(url, forKey: "newletterurl")
            UserDefaults.standard.synchronize()
            print(url)
        }) { (error) in
            print(error)
        }
    }
    
    func getProshowData(){
        Networking.sharedInstance.getProshowData(dataCompletion: { (data) in
            Caching.sharedInstance.saveProshowToCache(proshow: data)
        }) { (errorMessage) in
            print(errorMessage)
        }
    }
    
    fileprivate func getEvents(){
        var tags = [String]()
        tags.append("All")
        var eventsDictionary = [Int: Event]()
        Networking.sharedInstance.getData(url: eventsURL, decode: Event(), dataCompletion: { (data) in
            for event in data{
                if event.visible == 1{
                    eventsDictionary[event.id] = event
                    if let guardedTags = event.tags{
                        for tag in guardedTags{
                            if !tags.contains(tag){
                                tags.append(tag)
                            }
                        }
                    }
                }
            }
            Caching.sharedInstance.saveEventsToCache(events: data)
            Caching.sharedInstance.saveEventsDictionaryToCache(eventsDictionary: eventsDictionary)
            Caching.sharedInstance.saveTagsToCache(tags: tags)
        }) { (errorMessage) in
            print(errorMessage)
        }
    }
    
    fileprivate func getSchedule(){
        Networking.sharedInstance.getData(url: scheduleURL, decode: Schedule(), dataCompletion: { (data) in
            let revelsData = data.filter { (schedule) -> Bool in
                schedule.start > "2020-03-04T00:00:00.000Z"
            }
            Caching.sharedInstance.saveSchedulesToCache(schedule: revelsData)
        }) { (errorMessage) in
            print(errorMessage)
        }
    }
    
    fileprivate func getCategories() {
        var categoriesDictionary = [Int: Category]()
        Networking.sharedInstance.getCategories(dataCompletion: { (data) in
            for category in data {
                if category.type == "CULTURAL"{
                    categoriesDictionary[category.id] = category
                }
            }
            self.saveCategoriesDictionaryToCache(categoriesDictionary: categoriesDictionary)
        }) { (errorMessage) in
            print(errorMessage)
        }
    }
    
    func saveCategoriesDictionaryToCache(categoriesDictionary: [Int: Category]) {
        do {
            try Disk.save(categoriesDictionary, to: .caches, as: categoriesDictionaryCache)
        }
        catch let error {
            print(error)
        }
    }
}


extension AppDelegate{
    
    private func requestNotificationAuthorization(application: UIApplication){
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (success, error) in
            if let err = error{
                print(err)
            }
            UserDefaults.standard.set(success, forKey: "userHasEnabledFetch")
            UserDefaults.standard.synchronize()
        }
        application.registerForRemoteNotifications()
    }
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        //this function is used to save fcmToken in UserDefaults
        print("fcmToken: \(fcmToken)")
        UserDefaults.standard.set(fcmToken, forKey: "fcmToken")
        UserDefaults.standard.synchronize()
        
        if let subsDict = UserDefaults.standard.dictionary(forKey: "subsDictionary") as? [String: Bool]{
            print(subsDict)
            for (key, value) in subsDict{
                if value{
                    Messaging.messaging().subscribe(toTopic: key) { (err) in
                        if let err = err{
                            print(err)
                            return
                        }
                        print("subscribed to \(key)")
                    }
                }else{
                    print("false hai data")
                }
            }
        }else{
            print("cant find key par")
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        FBHandler(value: false)
    }


    func applicationDidBecomeActive(_ application: UIApplication) {
        FBHandler(value: true)
    }
    
    @objc func FBHandler(value: Bool) {
        Messaging.messaging().shouldEstablishDirectChannel = value
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print message ID.
//      if let messageID = userInfo[gcmMessageIDKey] {
//        print("Message ID: \(messageID)")
//      }

      // Print full message.
      print(userInfo)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print message ID.
//      if let messageID = userInfo[gcmMessageIDKey] {
//        print("Message ID: \(messageID)")
//      }

      // Print full message.
      print(userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        print(deviceTokenString)
    }
    
    // This method will be called when app received push notifications in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void){
        completionHandler([.alert, .badge, .sound])
    }
}

