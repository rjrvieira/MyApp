//
//  PostView.swift
//  MyApp
//
//  Created by Ricardo Vieira on 10/07/2020.
//  Copyright © 2020 Ricardo Vieira. All rights reserved.
//

import SwiftUI

struct PostView: View {
    var body: some View {
        
        VStack {
            
            Spacer()
            
            HStack {
                Image("profile")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 30, height: 30)
                    .clipped()
                    .cornerRadius(150)
                    .shadow(radius: 4)
                
                Text("Username")
                
                Spacer()
            }
            .padding(.horizontal)
            
            Image("background")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipped()
                .shadow(radius: 4)
            
            Spacer()
        }
        .padding(.vertical)
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}
