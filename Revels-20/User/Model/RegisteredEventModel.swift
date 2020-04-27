//
//  RegisteredEventModel.swift
//  TechTetva-19
//
//  Created by Naman Jain on 29/09/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

struct RegisteredEventsResponse: Decodable {
    let success: Bool
    let data : [RegisteredEvent]?
}

struct RegisteredEvent: Codable{
    let teamid: Int
    let event: Int
    let round: Int
    let delid: Int
}

