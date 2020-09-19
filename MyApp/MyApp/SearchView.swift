//
//  SearchView.swift
//  MyApp
//
//  Created by Ricardo Vieira on 12/07/2020.
//  Copyright © 2020 Ricardo Vieira. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    
    @ObservedObject var userLoggedIn: User
    
    @State var searchText = ""
    
    var body: some View {
        
        VStack {
            SearchBar(userLoggedIn: userLoggedIn, searchText: $searchText)
        }
    }
}

struct SearchBar: View {
    
    @ObservedObject var userLoggedIn: User
    
    @Binding var searchText: String
 
    @State private var isEditing = false
    
    @State var searchList = [UserDB]()
    
    @State var searchResults = [UserDB]()
    
    @State var imageLoader = ImageLoader(urlString: "http://vieiraapp.000webhostapp.com/\(UserDefaults.standard.string(forKey: "userPhoto") ?? "userPhotos/profile.png")")
    
    @State var image = UIImage(named: "profile")!
 
    var body: some View {
        
        let bindingSearch = Binding<String>(get: {
            self.searchText
        }, set: {
            self.searchText = $0
            self.search()
        })
        
        
        return NavigationView {
            
            VStack {
            
                TextField("Search ...", text: bindingSearch)
                    .padding(7)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 10)
                    .onAppear(perform: {self.getSearchList() {(searchList, error) in
                        self.searchList = searchList
                    }})
                    .onTapGesture {
                        self.isEditing = true
                    }
                
                            
                List(searchResults) { result in
                    
                    NavigationLink(destination: ProfileView(user: result, userLoggedIn: self.userLoggedIn)) {
                        
                        HStack {
                            
                            Image(uiImage: self.image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 30, height: 30)
                                .clipped()
                                .cornerRadius(150)
                                .shadow(radius: 4)
                                .onAppear(perform: {
                                    self.imageLoader = ImageLoader(urlString: "http://vieiraapp.000webhostapp.com/\(result.photo ?? "userPhotos/profile.png")")
                                })
                                .onReceive(self.imageLoader.didChange) { data in
                                    self.image = UIImage(data: data) ?? UIImage()
                                }
                            
                            Text(result.username)
                            
                        }
                    }
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
            
    func getSearchList(completion: @escaping (_ searchList: [UserDB], _ error: Error?)->()) {
          
        // Prepare URL
        let url = URL(string: "http://vieiraapp.000webhostapp.com/search.php")
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
                
                let searchList: [UserDB] = try! JSONDecoder().decode([UserDB].self, from: data)
                
                completion(searchList, error)
            }
        }
        task.resume()
    }
    
    func search() {
        
        searchResults.removeAll()
        
        for result in searchList {
            if result.username.lowercased().contains(self.searchText.lowercased()) {
                searchResults.append(result)
            }
        }
    }
}
