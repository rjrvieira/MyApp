//
//  SearchView.swift
//  MyApp
//
//  Created by Ricardo Vieira on 12/07/2020.
//  Copyright © 2020 Ricardo Vieira. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    
    @State var text = "teste"
    
    var body: some View {
        
        VStack {
            SearchBar(text: $text)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

struct SearchBar: View {
    @Binding var text: String
 
    @State private var isEditing = false
 
    var body: some View {
        
        VStack {
 
            TextField("Search ...", text: $text)
                .padding(7)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                }
            
            Spacer()
        }
    }
}
