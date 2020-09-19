//
//  User.swift
//  MyApp
//
//  Created by Ricardo Vieira on 10/07/2020.
//  Copyright © 2020 Ricardo Vieira. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class User: ObservableObject {
    
    @Published var username = UserDefaults.standard.string(forKey: "userLoggedIn")
    @Published var profilePhoto = Image("profile")
    @Published var urlPhoto = UserDefaults.standard.string(forKey: "userPhoto")
    @ObservedObject var imageLoader = ImageLoader(urlString: "http://vieiraapp.000webhostapp.com/\(UserDefaults.standard.string(forKey: "userPhoto") ?? "userPhotos/profile.png")")
    @State var image: UIImage = UIImage()
    
    func setPhoto(urlPhoto: String) {
        
        print("entrou1 ------")
        print("---> \(urlPhoto) <---")
        
        if urlPhoto != "null" {
            
            print("data1: \(imageLoader.data)")
            
            DispatchQueue.main.async {
                //self.imageLoader = ImageLoader(urlString: "http://vieiraapp.000webhostapp.com/\(urlPhoto)")
                

                print("entrou2 ------")
                print("-------- \(self.imageLoader.data)")
                self.image = UIImage(data: self.imageLoader.data) ?? UIImage(named: "profile")!
                self.profilePhoto = Image(uiImage: self.image)
            }
        }
    }
}
