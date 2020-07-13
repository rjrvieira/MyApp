//
//  HomeView.swift
//  MyApp
//
//  Created by Ricardo Vieira on 30/06/2020.
//  Copyright © 2020 Ricardo Vieira. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var userLoggedIn: User
    
    var body: some View {
        
        VStack {

            if userLoggedIn.username != nil && userLoggedIn.username != "" {
                HomeViewAux(userLoggedIn: userLoggedIn)
            }
            else {
                ContentView()
            }
        }
    }
}

struct HomeViewAux: View {
    
    @ObservedObject var userLoggedIn: User
    
    var body: some View {
        
        VStack {
            
            TabView {
                
                HomeScreenView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                }
                
                SearchView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                }
                
                ProfileView(userLoggedIn: userLoggedIn)
                    .tabItem {
                        Image(systemName: "person")
                        Text("Profile")
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(userLoggedIn: User())
    }
}

