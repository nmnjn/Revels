//
//  UserModel.swift
//  TechTetva-19
//
//  Created by Naman Jain on 27/09/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit

struct UserResponse: Decodable {
    let success: Bool
    let data : User?
}

struct User: Codable{
    let id: Int
    let name: String
    let regno: String
    let mobile: String
    let email: String
    let qr: String
    let collname: String
    
}
