//
//  UserDB.swift
//  MyApp
//
//  Created by Ricardo Vieira on 27/08/2020.
//  Copyright © 2020 Ricardo Vieira. All rights reserved.
//

import Foundation

struct UserDB: Codable, Identifiable {
    
    let id: String
    let username: String
    let photo: String?
}
