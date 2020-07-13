//
//  CreatePostView.swift
//  MyApp
//
//  Created by Ricardo Vieira on 12/07/2020.
//  Copyright © 2020 Ricardo Vieira. All rights reserved.
//

import SwiftUI

struct CreatePostView: View {
    
    @State var text = ""
    
    var body: some View {
        
        VStack {
            TextField("Write here...", text: $text)
            .padding(40)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal, 10)
            
            Button(action: {print("Publish")}) {
                Text("Publish")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(minHeight: 0, maxHeight: .infinity)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .cornerRadius(5)
                    .frame(width: 343, height: 35)
            
            }
        }
    }
}

struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostView()
    }
}
