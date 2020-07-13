//
//  HomeScreenView.swift
//  MyApp
//
//  Created by Ricardo Vieira on 10/07/2020.
//  Copyright © 2020 Ricardo Vieira. All rights reserved.
//

import SwiftUI

struct HomeScreenView: View {
    
    @State var showPostView = false
    
    var body: some View {
        
        VStack {
            
            if showPostView {
                PostView()
            }
            else {
                HomeScreenViewAux(showPostView: $showPostView)
            }
        }
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}

struct AddButton: View {
    
    @Binding var showPostView: Bool
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                
                // Add button
                Button(action: {self.showPostView = true}) {
                    Text("+")
                        .font(.system(size: 30))
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(minHeight: 0, maxHeight: .infinity)
                        .foregroundColor(Color.white)
                        .background(Color.blue)
                        .frame(width: 50, height: 50)
                        .cornerRadius(50)
                        .shadow(radius: 4)
                        .padding()
                    
                }
            }
        }
    }
}

struct HomeScreenViewAux: View {
    
    @Binding var showPostView: Bool
    
    var body: some View {
        ZStack {
            
            VStack {
                ScrollView(.horizontal) {
                    HStack(spacing: 20) {
                        ForEach(0..<10) { _ in
                            
                            Image("profile")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 40)
                                .clipped()
                                .cornerRadius(150)
                                .shadow(radius: 4)
                                .padding(.vertical, 5)
                            
                        }
                    }
                }
                
                ScrollView() {
                    
                    ForEach(0..<10) { _ in
                        
                        PostView()
                        
                    }
                }
            }
            
            AddButton(showPostView: $showPostView)
        }
    }
}
