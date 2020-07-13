//
//  RegisterView.swift
//  MyApp
//
//  Created by Ricardo Vieira on 27/06/2020.
//  Copyright © 2020 Ricardo Vieira. All rights reserved.
//

import SwiftUI
import CryptoKit

struct RegisterView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var name = ""
    @State var email = ""
    @State var username = ""
    @State var password = ""
    @State var confirmPassword = ""
    
    @State var buttonDisabled = true
    
    @State var warningText = ""
    
    @State var profilePhoto: UIImage? = nil
    
    @State var imageExtension: String? = ""
    
    @State var isLoading: Bool = false
    
    var body: some View {
        
        let bindingName = Binding<String>(get: {
            self.name
        }, set: {
            self.name = $0
            self.verifyInputs()
        })
        
        let bindingEmail = Binding<String>(get: {
            self.email
        }, set: {
            self.email = $0
            self.verifyInputs()
        })
        
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
        
        let bindingConfirmPassword = Binding<String>(get: {
            self.confirmPassword
        }, set: {
            self.confirmPassword = $0
            self.verifyInputs()
        })
        
        return VStack {
            LoadingView(isShowing: $isLoading) {
                RegisterForm(bindingName: bindingName, bindingEmail: bindingEmail, bindingUsername: bindingUsername, bindingPassword: bindingPassword, bindingConfirmPassword: bindingConfirmPassword, buttonDisabled: self.buttonDisabled, warningText: self.warningText, mainView: self)
            }
        }
    }
    
    
    func verifyInputs() {
        
        if name != "" && email != "" && username != "" && password != "" && confirmPassword != "" {
            buttonDisabled = false
        }
        else {
            buttonDisabled = true
        }
    }
    
    func register(completion: @escaping (_ response:String?, _ error:String?) -> Void) {
        
        if password != confirmPassword {
            warningText = "Passwords don't match"
            return;
        }
        
        // Encrypt password
        let inputData = Data(password.utf8)
        let hashedDescription = SHA256.hash(data: inputData)
        let hashedPassword = hashedDescription.compactMap { String(format: "%02x", $0) }.joined()

        let boundary: String = "------VohpleBoundary4QuqLuM1cE5lMwCy"
        let contentType: String = "multipart/form-data; boundary=\(boundary)"
        let request = NSMutableURLRequest()
        request.url = URL(string: "http://vieiraapp.000webhostapp.com/register.php")
        request.httpShouldHandleCookies = false
        request.timeoutInterval = 60
        request.httpMethod = "POST"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        let body = NSMutableData()
        
        // Send name, email, username and password throught POST request to the database
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition: form-data; name=\"name\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\(name)\r\n".data(using: String.Encoding.utf8)!)
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition: form-data; name=\"email\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\(email)\r\n".data(using: String.Encoding.utf8)!)
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition: form-data; name=\"username\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\(username)\r\n".data(using: String.Encoding.utf8)!)
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition: form-data; name=\"password\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\(hashedPassword)\r\n".data(using: String.Encoding.utf8)!)
        
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
                self.warningText = "\(response)"
                DispatchQueue.main.async { completion(response, nil) }
            }
            // NO response
            else { DispatchQueue.main.async { completion(nil, "E_401") } }
        }
        task.resume()
    }
}

struct RegisterForm: View {
    
    let bindingName: Binding<String>
    let bindingEmail: Binding<String>
    let bindingUsername: Binding<String>
    let bindingPassword: Binding<String>
    let bindingConfirmPassword: Binding<String>
    
    var buttonDisabled: Bool
    
    var warningText: String
    
    let mainView: RegisterView
    
    @State var imagePicker = false
    @State var image: Image? = Image("profile")
    
    @State var showingAlert = false
    
    var body: some View {
        
        ZStack {
            VStack {
                
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
                
                Button(action: {
                    withAnimation() {
                        self.imagePicker.toggle()
                    }
                }) {
                    Text("Choose profile photo")
                        .padding(.bottom)
                }
                
                TextField("Name", text: bindingName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                TextField("Email", text: bindingEmail)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                TextField("Username", text: bindingUsername)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                SecureField("Password", text: bindingPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                SecureField("Confirm Password", text: bindingConfirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Text("\(warningText)")
                    .foregroundColor(Color.red)
                    .padding()
                
                Button(action: {
                    
                    self.mainView.isLoading.toggle()
                    
                    self.mainView.register() { (response, e) in
                        print("Resposta: \(response ?? "NIL RESPONSE")")
                        if e == nil && response == "Successfully registered"{
                            DispatchQueue.main.async {
                                self.mainView.isLoading.toggle()
                                self.mainView.presentationMode.wrappedValue.dismiss()
                                self.showingAlert.toggle()
                            }
                        }
                    }
                    
                }) {
                    Text("Register")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(minHeight: 0, maxHeight: .infinity)
                        .background(buttonDisabled ? .secondary : Color.blue)
                        .foregroundColor(Color.white)
                        .opacity(buttonDisabled ? 0.5 : 1)
                        .cornerRadius(5)
                        .frame(width: 343, height: 35)
                        .padding(.top)
                        .disabled(buttonDisabled)
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Successfully registered"), message: Text("Enjoy!"), dismissButton: .default(Text("Got it!")))
                }
                
                Spacer()
            }
        }
        .sheet(isPresented: $imagePicker) {
            ImagePicker(image: self.$image, profilePhoto: self.mainView.$profilePhoto, imageExtension: self.mainView.$imageExtension)
        }
    }
}


struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
