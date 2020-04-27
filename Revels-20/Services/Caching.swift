//
//  Caching.swift
//  TechTetva-19
//
//  Created by Naman Jain on 29/08/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import Disk


let eventsDictionaryCache = "eventsDictionary.json"
let scheduleCache = "schedule.json"
let categoriesDictionaryCache = "categoriesDictionary.json"
let userDetailsCache = "userDetails.json"
let scheduleDictCache = "scheduleDictCache.json"
let delegateCardsDictionaryCache = "delegateCards.json"
let tagsCache = "tags.json"
let eventsCache = "events.json"
let proshowCache = "proshow.json"
let delegateCardsCache = "delegateCardsCache.json"

let sponsorsCache = "sponsorsCache.json"

struct Caching{
    
    static let sharedInstance = Caching()
    
    func getCachedData<T: Codable>(dataType: T, cacheLocation: String,  dataCompletion: @escaping (_ Data: T) -> (),  errorCompletion: @escaping (_ errorMesssage: String) -> ()){
        do{
            let retrievedData = try Disk.retrieve(cacheLocation, from: .caches, as: T.self)
            dataCompletion(retrievedData)
        }catch{
            errorCompletion("Cache not found")
        }
    }
    
    
    func saveEventsDictionaryToCache(eventsDictionary: [Int: Event]){
        do{
            try Disk.save(eventsDictionary, to: .caches, as: eventsDictionaryCache)
        }catch let error{
            print(error)
        }
    }
    
    func saveTagsToCache(tags: [String]){
        do{
            try Disk.save(tags, to: .caches, as: tagsCache)
        }catch let error{
            print(error)
        }
    }
    
    func saveEventsToCache(events: [Event]){
        do{
            try Disk.save(events, to: .caches, as: eventsCache)
        }catch let error{
            print(error)
        }
    }
    
    func saveProshowToCache(proshow: ProResponse){
        do{
            try Disk.save(proshow, to: .caches, as: proshowCache)
        }catch let error{
            print(error)
        }
    }
    
    func saveSponsorsToCache(sponsors: [SponsorsData]){
        do{
            try Disk.save(sponsors, to: .caches, as: sponsorsCache)
        }catch let error{
            print(error)
        }
    }
    
    func saveDelegateCardsDictionaryToCache(dict: [Int: DelegateCard]){
        do{
            try Disk.save(dict, to: .caches, as: delegateCardsDictionaryCache)
        }catch let error{
            print(error)
        }
    }
    
    func saveDelegateCardsToCache(cards: [DelegateCard]){
        do{
            try Disk.save(cards, to: .caches, as: delegateCardsCache)
        }catch let error{
            print(error)
        }
    }
    
    func saveSchedulesToCache(schedule: [Schedule]){
        var scheduleDictionary : [String: Schedule] = [:]
        for sc in schedule{
            scheduleDictionary["\(sc.eventId)+\(sc.round)"] = sc
        }
        do{
            try Disk.save(scheduleDictionary, to: .caches, as: scheduleDictCache)
            try Disk.save(schedule, to: .caches, as: scheduleCache)
        }catch let error{
            print(error)
        }
    }
    
    func saveUserDetailsToCache(user: User?){
        do{
            try Disk.save(user, to: .caches, as: userDetailsCache)
        }catch let error{
            print(error)
        }
    }
    
    func getUserDetailsFromCache() -> User? {
        do{
            let retrievedData = try Disk.retrieve(userDetailsCache, from: .caches, as: User.self)
            return retrievedData
        }catch let err{
            print(err)
            return nil
        }
    }
    
    
    func getTagsFromCache() -> [String] {
        do{
            let retrievedData = try Disk.retrieve(tagsCache, from: .caches, as: [String].self)
            return retrievedData
        }catch let err{
            print(err)
            return []
        }
    }
    
    func getEventsFromCache() -> [Event] {
        do{
            let retrievedData = try Disk.retrieve(eventsCache, from: .caches, as: [Event].self)
            return retrievedData
        }catch let err{
            print(err)
            return []
        }
    }
    
    func getDelegateCardsFromCache() -> [DelegateCard]? {
        do{
            let retrievedData = try Disk.retrieve(delegateCardsCache, from: .caches, as: [DelegateCard].self)
            return retrievedData
        }catch let err{
            print(err)
            return nil
        }
    }
    
    func getProshowFromCache() -> ProResponse? {
        do{
            let retrievedData = try Disk.retrieve(proshowCache, from: .caches, as: ProResponse.self)
            return retrievedData
        }catch let err{
            print(err)
            return nil
        }
    }
    
    func getSponsorsFromCache() -> [SponsorsData]? {
        do{
            let retrievedData = try Disk.retrieve(sponsorsCache, from: .caches, as: [SponsorsData].self)
            return retrievedData
        }catch let _{
            print("sponsors cache not found")
            return nil
        }
    }
}
