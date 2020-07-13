//
//  ProfileView.swift
//  MyApp
//
//  Created by Ricardo Vieira on 10/07/2020.
//  Copyright © 2020 Ricardo Vieira. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var userLoggedIn: User
    
    @State var showEditProfileView = false
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                /*NavigationLink(destination: EditProfileView(), isActive: $showEditProfileView) {
                    EmptyView()
                }*/
                

                userLoggedIn.profilePhoto
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .clipped()
                    .cornerRadius(150)
                    .shadow(radius: 4)
                    
                    
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
            }
            .navigationBarItems(trailing: Button(action: {EditProfileView()}) {
                Text("Edit Profile")
            })
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(userLoggedIn: User())
    }
}
