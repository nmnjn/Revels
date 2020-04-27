//
//  Categories.swift
//  TechTetva-19
//
//  Created by Vedant Jain on 26/08/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

struct CategoriesResponse: Codable {
    let success: Bool
    let data: [Category]?
}

struct Category: Codable {
    let id: Int
    let name: String
    let type: String
    let description: String?
    let cc1Name: String?
    let cc1Contact: String?
    let cc2Name: String?
    let cc2Contact: String?
}

