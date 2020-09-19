//
//  ProfileView.swift
//  MyApp
//
//  Created by Ricardo Vieira on 26/08/2020.
//  Copyright © 2020 Ricardo Vieira. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    
    let user: UserDB
    
    @ObservedObject var userLoggedIn: User
    
    @State var imageLoader = ImageLoader(urlString: "http://vieiraapp.000webhostapp.com/\(UserDefaults.standard.string(forKey: "userPhoto") ?? "userPhotos/profile.png")")
    
    @State var image = UIImage(named: "profile")!
    
    @State var follow = false
    
    @State var followers = 0
    
    @State var following = 0
    
    var body: some View {
        
        VStack {
        
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .clipped()
                .cornerRadius(150)
                .shadow(radius: 4)
                .onAppear(perform: {
                    self.imageLoader = ImageLoader(urlString: "http://vieiraapp.000webhostapp.com/\(self.user.photo ?? "userPhotos/profile.png")")
                    self.getProfileInfo()
                })
                .onReceive(imageLoader.didChange) { data in
                    self.image = UIImage(data: data) ?? UIImage()
                }
                
            Text("\(user.username)")
            
            HStack {
                VStack {
                    Text("Followers")
                    Text("\(followers)")
                }
                
                VStack {
                    Text("Following")
                    Text("\(following)")
                }
            }
            .padding(.top)
            
            Button(action: {self.followUser()}) {
                
                Text(follow ? "Following" : "Follow")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(minHeight: 0, maxHeight: .infinity)
                    .background(follow ? Color.black : Color.blue)
                    .foregroundColor(Color.white)
                    .cornerRadius(5)
                    .frame(width: 143, height: 30)
                    .padding(.vertical)
            }
            
            Spacer()
        }
    }
    
    func getProfileInfo(/*completion: @escaping (_ dataString: String, _ error: Error?)->()*/) {
        
        // Prepare URL
        let url = URL(string: "http://vieiraapp.000webhostapp.com/getProfileInfo.php")
        guard let requestUrl = url else { fatalError() }
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
         
        // HTTP Request Parameters which will be sent in HTTP Request Body
        let postString = "userLoggedIn=\(userLoggedIn.username!)&targetUser=\(user.username)";
        // Set HTTP Request Body
        request.httpBody = postString.data(using: String.Encoding.utf8);
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                // Check for Error
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
         
                // Convert HTTP Response Data to a String
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print("Response data string:\n \(dataString)")
                    
                    let parts = dataString.components(separatedBy: "|")
                    
                    if parts[0] == "true" {
                        self.follow = true
                    }
                    else {
                        self.follow = false
                    }
                    self.following = Int(parts[1])!
                    self.followers = Int(parts[2])!
                    
                    //completion(dataString, error)
                }
        }
        task.resume()
        
    }
    
    func followUser(/*completion: @escaping (_ dataString: String, _ error: Error?)->()*/) {
        
        // Prepare URL
        let url = URL(string: "http://vieiraapp.000webhostapp.com/followUser.php")
        guard let requestUrl = url else { fatalError() }
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
         
        // HTTP Request Parameters which will be sent in HTTP Request Body
        let postString = "userLogged=\(userLoggedIn.username!)&targetUser=\(user.username)";
        // Set HTTP Request Body
        request.httpBody = postString.data(using: String.Encoding.utf8);
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                // Check for Error
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
         
                // Convert HTTP Response Data to a String
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print("Response data string:\n \(dataString)")
                    
                    let parts = dataString.components(separatedBy: "|")
                    
                    if parts[0] == "true" {
                        self.follow = true
                    }
                    else if parts[0] == "false" {
                        self.follow = false
                    }
                    
                    self.followers = Int(parts[1])!
                }
        }
        task.resume()
    }
}
