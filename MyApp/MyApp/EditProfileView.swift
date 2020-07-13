//
//  EditProfileView.swift
//  MyApp
//
//  Created by Ricardo Vieira on 11/07/2020.
//  Copyright © 2020 Ricardo Vieira. All rights reserved.
//

import SwiftUI

struct EditProfileView: View {
    var body: some View {
        
        VStack {
            HStack {
                Button(action: {print("Close")}) {
                Image(systemName: "multiply")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 20, height: 20)
                    .clipped()
                }
                    
                Spacer()
                    
                Button(action: {print("Save")}) {
                    Image(systemName: "checkmark")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 20, height: 20)
                        .clipped()
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            Text("Edit Profile")
            
            Spacer()
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
