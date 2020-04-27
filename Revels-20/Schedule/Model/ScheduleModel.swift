//
//  ScheduleModel.swift
//  TechTetva-19
//
//  Created by Naman Jain on 26/08/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//
    
struct ScheduleResponse: Codable{
    let success: Bool
    let data: [Schedule]?
}

struct Schedule: Codable{
    let id: Int
    let eventId: Int
    let round: Int
    let start: String
    let end: String
    let location: String
    let eventName: String
    
    init() {
        id = 0
        eventId = 0
        round = 0
        start = ""
        end = ""
        location = ""
        eventName = ""
    }
}
