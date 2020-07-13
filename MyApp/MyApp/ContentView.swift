//
//  ContentView.swift
//  MyApp
//
//  Created by Ricardo Vieira on 26/06/2020.
//  Copyright © 2020 Ricardo Vieira. All rights reserved.
//

import SwiftUI
import CryptoKit

struct ContentView: View {
    
    @ObservedObject var userLoggedIn = User()
    
    var body: some View {

        VStack {
            
            if userLoggedIn.username != nil && userLoggedIn.username != "" {
                HomeView(userLoggedIn: userLoggedIn)
            }
            else {
                LoginView(userLoggedIn: userLoggedIn)
            }
        }
    }
}

struct LabelledDivider: View {
    var body: some View {
        HStack {
            Rectangle()
                .fill(Color.gray)
                .frame(height: 1)
            
            
            Text("OR")
                .foregroundColor(.secondary)
                .padding()
            
            
            Rectangle()
                .fill(Color.gray)
                .frame(height: 1)
        }
        .padding(.horizontal, 17)
    }
}

struct LoginView: View {
    
    @ObservedObject var userLoggedIn: User
    
    @State var username = ""
    @State var password = ""
    
    @State var buttonDisabled = true
    
    @ObservedObject var imageLoader = ImageLoader(urlString: "http://vieiraapp.000webhostapp.com/userPhotos/Qwert.jpeg")
    @State var image:UIImage = UIImage()
    
    var body: some View {
        
        let bindingUsername = Binding<String>(get: {
            self.username
        }, set: {
            self.username = $0
            self.verifyInputs()
        })
        
        let bindingPassword = Binding<String>(get: {
            self.password
        }, set: {
            self.password = $0
            self.verifyInputs()
        })
        
        return NavigationView {
            
            VStack {
                
                Spacer()
                
                
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:100, height:100)
                    .onReceive(imageLoader.didChange) { data in
                    self.image = UIImage(data: data) ?? UIImage()
                }
                
                TextField("Username", text: bindingUsername)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                SecureField("Password", text: bindingPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                LoginButton(loginView: self, userLoggedIn: userLoggedIn)
                
                LabelledDivider()
                
                NavigationLink(destination: RegisterView()) {
                    Text("Register")
                        .foregroundColor(Color.blue)
                }
                
                Spacer()
                
                Text("developed by Ricardo Vieira")
            }
        }
    }
    
    func verifyInputs() {
        
        if username != "" && password != "" {
           buttonDisabled = false
        }
        else {
           buttonDisabled = true
        }
    }
}

struct LoginButton: View {
    
    let loginView: LoginView
    
    @ObservedObject var userLoggedIn: User
    
    var body: some View {
        
        Button(action: {
            
            self.login() {
                dataString, error in
                print("--> \(String(describing: dataString))")
                if dataString == "Successfully logged in" {
                    let defaults = UserDefaults.standard
                    defaults.set(self.loginView.username, forKey: "userLoggedIn")
                    DispatchQueue.main.async {
                        self.userLoggedIn.username = self.loginView.username
                    }
                }
            }
        }) {
            Text("Login")
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(minHeight: 0, maxHeight: .infinity)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .cornerRadius(5)
                .frame(width: 343, height: 35)
                .padding(.top)
        }
    }
    
    func login(completion: @escaping (_ dataString: String, _ error: Error?)->()) {
        
        // Encrypt password
        let inputData = Data(loginView.password.utf8)
        let hashedDescription = SHA256.hash(data: inputData)
        let hashedPassword = hashedDescription.compactMap { String(format: "%02x", $0) }.joined()
        
        print("hashedPass: \(hashedPassword)")
        
        // Prepare URL
        let url = URL(string: "http://vieiraapp.000webhostapp.com/login.php")
        guard let requestUrl = url else { fatalError() }
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
         
        // HTTP Request Parameters which will be sent in HTTP Request Body
        let postString = "username=\(loginView.username)&password=\(hashedPassword)";
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
                    
                    if dataString == "Successfully logged in" {
                        completion(dataString, error)
                    }
                }
        }
        task.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
