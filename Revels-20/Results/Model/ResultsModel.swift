//
//  ResultsModel.swift
//  TechTetva-19
//
//  Created by Naman Jain on 26/08/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

struct ResultsResponse: Codable{
    let success: Bool
    let data: [Result]?
}

struct Result: Codable{
    let event: Int
    let teamid: Int
    let position: Int
    let round: Int
}

