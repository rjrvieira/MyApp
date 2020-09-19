//
//  SwiftUIList.swift
//  MyApp
//
//  Created by Ricardo Vieira on 19/07/2020.
//  Copyright © 2020 Ricardo Vieira. All rights reserved.
//

import SwiftUI

struct SwiftUIList: View {
    
    @Binding var posts: [Post]
    
    var body: some View {
        /*List(model.modelData){
            model in
            Text(model.title)
        }*/
        
        List(posts){
            post in
            PostView(post: post)
        }
        
        /*ScrollView() {
            ForEach(0..<10) { _ in
                
                PostView()
                
            }
        }*/
    }
}
