//
//  HomeScreenView.swift
//  MyApp
//
//  Created by Ricardo Vieira on 10/07/2020.
//  Copyright © 2020 Ricardo Vieira. All rights reserved.
//

import SwiftUI

struct HomeScreenView: View {
    
    @ObservedObject var userLoggedIn: User
    
    @State var showCreatePostView = false
    
    @State var posts = [Post]()
    
    var body: some View {
        
        VStack {
            
            if showCreatePostView {
                CreatePostView(userLoggedIn: userLoggedIn, showCreatePostView: $showCreatePostView)
                    .transition(AnyTransition.move(edge: .trailing))
            }
            else {
                HomeScreenViewAux(showCreatePostView: $showCreatePostView, posts: $posts)
            }
        }.onAppear(perform: {self.getFeed() {(posts, error) in
            self.posts = posts
        }})
    }
    
    func getFeed(completion: @escaping (_ posts: [Post], _ error: Error?)->()) {
        
        // Prepare URL
        let url = URL(string: "http://vieiraapp.000webhostapp.com/getFeed.php")
        guard let requestUrl = url else { fatalError() }
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
         
        // HTTP Request Parameters which will be sent in HTTP Request Body
        let postString = "username=\(userLoggedIn.username!)";
        // Set HTTP Request Body
        request.httpBody = postString.data(using: String.Encoding.utf8);
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                // Check for Error
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
         
                // Convert HTTP Response Data to a String
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print("Response data string:\n \(dataString)")
                    
                    let posts: [Post] = try! JSONDecoder().decode([Post].self, from: data)
                    
                    completion(posts, error)
                }
        }
        task.resume()
    }
}

struct HomeScreenViewAux: View {
    
    @Binding var showCreatePostView: Bool
    
    @Binding var posts: [Post]
    
    @State var imageLoader = ImageLoader(urlString: "http://vieiraapp.000webhostapp.com/\(UserDefaults.standard.string(forKey: "userPhoto") ?? "userPhotos/profile.png")")
    
    @State var image: UIImage = UIImage(named: "profile")!
    
    var body: some View {
        
        ZStack {
            
            VStack {
                ScrollView(.horizontal) {
                    HStack(spacing: 20) {
                        ForEach(0..<10) { _ in
                            
                            Image(uiImage: self.image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 40)
                                .clipped()
                                .cornerRadius(150)
                                .shadow(radius: 4)
                                .padding(.vertical, 5)
                                .onAppear(perform: {
                                    self.imageLoader = ImageLoader(urlString: "http://vieiraapp.000webhostapp.com/\(UserDefaults.standard.string(forKey: "userPhoto") ?? "userPhotos/profile.png")")
                                })
                                .onReceive(self.imageLoader.didChange) { data in
                                    self.image = UIImage(data: data) ?? UIImage()
                                }
                        }
                    }
                }
                
                GeometryReader{
                    geometry in
                    CustomScrollView(width: geometry.size.width, height: geometry.size.height, posts: self.$posts)
                }
                
                
                //ScrollView() {
                
                /*List {
                    ForEach(0..<10) { _ in
                        
                        PostView()
                        
                    }
                }*/
            }
            
           
            CreatePostButton(showCreatePostView: $showCreatePostView)
        }
    }
}

struct CreatePostButton: View {
    
    @Binding var showCreatePostView: Bool
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                
                // Add button
                Button(action: {
                    withAnimation {
                        self.showCreatePostView = true
                    }
                }) {
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

struct CustomScrollView : UIViewRepresentable {
    
    var width : CGFloat
    var height : CGFloat
    
    @Binding var posts: [Post]
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, posts: posts)
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        let control = UIScrollView()
        control.refreshControl = UIRefreshControl()
        control.refreshControl?.addTarget(context.coordinator, action: #selector(Coordinator.handleRefreshControl), for: .valueChanged)
    
        let childView = UIHostingController(rootView: SwiftUIList(posts: $posts))
        childView.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        control.addSubview(childView.view)
        return control
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {}
    
    class Coordinator: NSObject {
        
        var control: CustomScrollView
        var posts : [Post]
        
        init(_ control: CustomScrollView, posts: [Post]) {
            self.control = control
            self.posts = posts
        }
        
        @objc func handleRefreshControl(sender: UIRefreshControl) {
            sender.endRefreshing()
            print("Refresh")
        }
    }
}
