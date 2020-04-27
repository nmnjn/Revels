//
//  DelegateCardsModel.swift
//  TechTetva-19
//
//  Created by Naman Jain on 30/09/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

struct DelegateCard: Codable {
    let id: Int
    let name: String
    let description: String
    let MAHE_price: Int
    let non_price: Int
    let forSale: Int
    let type: String
    let payment_mode: Int
    init() {
        id = 0
        name = ""
        description = ""
        MAHE_price = 0
        non_price = 0
        forSale = 0
        type = ""
        payment_mode = 0
    }
}

struct BlogData: Codable{
    let numUpdates: Int
    let data: [Blog]?
}

struct Blog: Codable{
    let author: String
    let content: String
    let id: Int
    let imageURL: String
    let timestamp: String
}


struct BoughtDelegateCard: Codable {
    var success: Bool
    var msg: String
    var data: [CardTypeStruct]
}

struct CardTypeStruct: Codable{
    var card_type: Int
}
