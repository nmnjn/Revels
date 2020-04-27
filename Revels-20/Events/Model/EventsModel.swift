//
//  EventsModel.swift
//  TechTetva-19
//
//  Created by Naman Jain on 26/08/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

struct EventsResponse: Codable{
    let success: Bool
    let data: [Event]?
}

struct Event: Codable{
    let id: Int
    let category: Int
    let name: String
    let shortDesc: String
    let longDesc: String
    let minTeamSize: Int
    let maxTeamSize: Int
    let delCardType: Int
    let can_register: Int
    let visible: Int
    let tags: [String]?
    
    init() {
        id = 0
        category = 0
        name = ""
        shortDesc = ""
        longDesc = ""
        minTeamSize = 0
        maxTeamSize = 0
        delCardType = 0
        can_register = 0
        visible = 0
        tags = []
    }
}

