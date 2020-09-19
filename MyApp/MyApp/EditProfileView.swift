//
//  EditProfileView.swift
//  MyApp
//
//  Created by Ricardo Vieira on 11/07/2020.
//  Copyright © 2020 Ricardo Vieira. All rights reserved.
//

import SwiftUI

struct EditProfileView: View {
    
    @ObservedObject var userLoggedIn: User
    
    @Binding var showEditProfileView: Bool
    
    @Binding var profileViewImage: UIImage
    
    @State var imagePicker = false
    
    @State var imageLoader = ImageLoader(urlString: "http://vieiraapp.000webhostapp.com/\(UserDefaults.standard.string(forKey: "userPhoto") ?? "userPhotos/profile.png")")
    
    //@State var image: UIImage = UIImage(named: "profile")!
    
    @State var image: Image? = Image("profile")
    
    @State var profilePhoto: UIImage? = nil
    
    @State var imageExtension: String? = ""
    
    var body: some View {
        
        ZStack {
            VStack {
                HStack {
                    Button(action: {
                        withAnimation {
                            self.showEditProfileView = false
                        }
                    }) {
                    Image(systemName: "multiply")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 20, height: 20)
                        .clipped()
                    }
                        
                    Spacer()
                        
                    Button(action: {
                        print("SAVE CHANGES")
                        self.saveChanges() { (response, e) in
                            print("Resposta: \(response ?? "NIL RESPONSE")")
                            if e == nil && response == "Successfully registered"{
                                DispatchQueue.main.async {
                                    
                                }
                            }
                            withAnimation {
                                self.showEditProfileView = false
                            }
                        }
                    }) {
                        Image(systemName: "checkmark")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 20, height: 20)
                            .clipped()
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                image?
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .clipped()
                    .cornerRadius(150)
                    .shadow(radius: 4)
                    .onTapGesture {
                        self.imagePicker.toggle()
                    }
                    .onAppear(perform: {
                        self.imageLoader = ImageLoader(urlString: "http://vieiraapp.000webhostapp.com/\(UserDefaults.standard.string(forKey: "userPhoto") ?? "userPhotos/profile.png")")
                    })
                    .onReceive(imageLoader.didChange) { data in
                        self.profilePhoto = UIImage(data: data) ?? UIImage()
                        self.image = Image(uiImage: self.profilePhoto!)
                        self.profileViewImage = UIImage(data: data) ?? UIImage(named: "profile")!
                    }
                
                Button(action: {
                    withAnimation() {
                        self.imagePicker.toggle()
                    }
                }) {
                    Text("Change profile photo")
                        .padding(.bottom)
                }
                
                Spacer()
            }
        }
        .sheet(isPresented: $imagePicker) {
            ImagePicker(image: self.$image, profilePhoto: self.$profilePhoto, imageExtension: self.$imageExtension)
        }
    }
    
    func saveChanges(completion: @escaping (_ response:String?, _ error:String?) -> Void) {
        
        let boundary: String = "------VohpleBoundary4QuqLuM1cE5lMwCy"
        let contentType: String = "multipart/form-data; boundary=\(boundary)"
        let request = NSMutableURLRequest()
        request.url = URL(string: "http://vieiraapp.000webhostapp.com/saveChanges.php")
        request.httpShouldHandleCookies = false
        request.timeoutInterval = 60
        request.httpMethod = "POST"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        let body = NSMutableData()
        
        // Send username throught POST request
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition: form-data; name=\"username\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\(userLoggedIn.username!)\r\n".data(using: String.Encoding.utf8)!)
        print("\(userLoggedIn.username!)")
        
        // If the user has chosen a profile photo, then we will send it through POST request
        if profilePhoto != nil {
            
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition: form-data; name=\"hasProfilePhoto\"\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("1\r\n".data(using: String.Encoding.utf8)!)

            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"file\"\r\n".data(using: String.Encoding.utf8)!)
            
            // File extension is jpg
            if imageExtension == "jpg" {
                body.append("Content-Type:png\r\n\r\n".data(using: String.Encoding.utf8)!)
            // File extension is a jpeg
            }
            else if imageExtension == "jpeg" {
                body.append("Content-Type:jpeg\r\n\r\n".data(using: String.Encoding.utf8)!)
            }
            // File extension is a png
            else if imageExtension == "png" {
                body.append("Content-Type:png\r\n\r\n".data(using: String.Encoding.utf8)!)
            }

            body.append(profilePhoto!.pngData()!)
            body.append("\r\n".data(using: String.Encoding.utf8)!)
        }
            
        // We don't need to send the photo, since the user didn't choose any photo
        else {
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition: form-data; name=\"hasProfilePhoto\"\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("0\r\n".data(using: String.Encoding.utf8)!)
        }


        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        request.httpBody = body as Data
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            // In case of error
            guard let _:Data = data as Data?, let _:URLResponse = response, error == nil else {
                DispatchQueue.main.async { completion(nil, error!.localizedDescription) }
                return
            }
            
            // Convert the response to String, show the response to user and call completion
            if let response = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                //self.warningText = "\(response)"
                DispatchQueue.main.async { completion(response, nil) }
            }
            // NO response
            else { DispatchQueue.main.async { completion(nil, "E_401") } }
        }
        task.resume()
    }
}
