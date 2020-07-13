//
//  User.swift
//  MyApp
//
//  Created by Ricardo Vieira on 10/07/2020.
//  Copyright © 2020 Ricardo Vieira. All rights reserved.
//

import Foundation
import SwiftUI

class User: ObservableObject {
    
    @Published var username = UserDefaults.standard.string(forKey: "userLoggedIn")
    @Published var profilePhoto = Image("profile")
    
}
