//
//  OwnProfileView.swift
//  MyApp
//
//  Created by Ricardo Vieira on 10/07/2020.
//  Copyright © 2020 Ricardo Vieira. All rights reserved.
//

import SwiftUI

struct OwnProfileView: View {
    
    @ObservedObject var userLoggedIn: User
    
    @State var showEditProfileView = false
    
    @State var image: UIImage = UIImage(named: "profile")!
    
    var body: some View {
        
        VStack {
            
            if showEditProfileView {
                EditProfileView(userLoggedIn: userLoggedIn, showEditProfileView: $showEditProfileView, profileViewImage: $image)
                    .transition(AnyTransition.move(edge: .trailing))
            }
            else {
                OwnProfileViewAux(userLoggedIn: userLoggedIn, showEditProfileView: $showEditProfileView, image: $image)
            }
        }
    }
}

struct OwnProfileViewAux: View {
    
    @ObservedObject var userLoggedIn: User
    
    @Binding var showEditProfileView: Bool
    
    @State var imageLoader = ImageLoader(urlString: "http://vieiraapp.000webhostapp.com/\(UserDefaults.standard.string(forKey: "userPhoto") ?? "userPhotos/profile.png")")
    
    @Binding var image: UIImage
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        self.showEditProfileView = true
                    }}) {
                    Text("Edit Profile")
                }
            }
            .padding()
            
            Spacer()
        
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .clipped()
                .cornerRadius(150)
                .shadow(radius: 4)
                .onAppear(perform: {
                    self.imageLoader = ImageLoader(urlString: "http://vieiraapp.000webhostapp.com/\(UserDefaults.standard.string(forKey: "userPhoto") ?? "userPhotos/profile.png")")
                })
                .onReceive(imageLoader.didChange) { data in
                    self.image = UIImage(data: data) ?? UIImage()
                } 
                
                
            Text("\(userLoggedIn.username!)")

            
            HStack {
                Text("Followers")
                Text("Following")
            }
            
            Button(action: {
                let defaults = UserDefaults.standard
                defaults.set(nil, forKey: "userLoggedIn")
                self.userLoggedIn.username = ""
            }) {
                Text("Logout")
            }
            
            Spacer()
        }
    }
}
