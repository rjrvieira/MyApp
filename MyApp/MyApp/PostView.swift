//
//  PostView.swift
//  MyApp
//
//  Created by Ricardo Vieira on 20/07/2020.
//  Copyright © 2020 Ricardo Vieira. All rights reserved.
//

import SwiftUI

struct PostView: View {
    
    @State var post: Post
    
    @State var imageLoader = ImageLoader(urlString: "http://vieiraapp.000webhostapp.com/userPhotos/profile.png")
       
    @State var image: UIImage = UIImage(named: "profile")!
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            HStack {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 30, height: 30)
                    .clipped()
                    .cornerRadius(150)
                    .shadow(radius: 4)
                    .onAppear(perform: {
                        if self.post.photo != nil {
                            print("FOTO: \(self.post.photo!)")
                            self.imageLoader = ImageLoader(urlString: "http://vieiraapp.000webhostapp.com/\(self.post.photo ?? "userPhotos/profile.png")")
                        }
                    })
                    .onReceive(imageLoader.didChange) { data in
                        self.image = UIImage(data: data) ?? UIImage()
                    }
                
                Text("\(post.username)")
                
                Spacer()
            }
            .padding(.horizontal)
            
            Text("\(post.text)")
            
            /*Image("background")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipped()
                .shadow(radius: 4)*/
            
            Spacer()
        }
        .padding(.vertical)
    }
}
