//
//  Post.swift
//  MyApp
//
//  Created by Ricardo Vieira on 18/07/2020.
//  Copyright © 2020 Ricardo Vieira. All rights reserved.
//

import Foundation

struct Post: Codable, Identifiable {
    
    let id = UUID()
    let username: String
    let photo: String?
    let text: String
}
