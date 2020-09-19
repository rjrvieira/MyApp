//
//  CreatePostView.swift
//  MyApp
//
//  Created by Ricardo Vieira on 12/07/2020.
//  Copyright © 2020 Ricardo Vieira. All rights reserved.
//

import SwiftUI

struct CreatePostView: View {
    
    @ObservedObject var userLoggedIn: User
    
    @Binding var showCreatePostView: Bool
    
    @State var text = "Write here..."
    
    @State var warningText = ""
    
    var body: some View {
        
        VStack {
            
            HStack {
                Button(action: {
                    withAnimation {
                        self.showCreatePostView = false
                    }
                }) {
                    Image(systemName: "chevron.left")
                }
                
                Spacer()
            }
            .padding()
            
            Spacer()
            
            MultilineTextView(text: $text)
                .cornerRadius(5)
                .frame(height: 150)
                .shadow(radius: 4)
                .padding()
                .onTapGesture {
                    self.text = ""
                }
            
            Text("\(warningText)")
            
            Button(action: {
                self.publishPost() { (response, error) in
                    if response == "Successfully posted" {
                        self.showCreatePostView = false
                    }
                    else {
                        self.warningText = response
                    }
                }
                
            }) {
                Text("Publish")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(minHeight: 0, maxHeight: .infinity)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .cornerRadius(5)
                    .frame(width: 343, height: 35)
            
            }
            
            Spacer()
        }
    }
    
    func publishPost(completion: @escaping (_ dataString: String, _ error: Error?)->()) {
        
        // Prepare URL
        let url = URL(string: "http://vieiraapp.000webhostapp.com/createPost.php")
        guard let requestUrl = url else { fatalError() }
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
         
        // HTTP Request Parameters which will be sent in HTTP Request Body
        let postString = "username=\(userLoggedIn.username!)&text=\(text)";
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
                    
                    completion(dataString, error)
                }
        }
        task.resume()
    }
}

struct MultilineTextView: UIViewRepresentable {
    
    @Binding var text: String

    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        view.font = UIFont(name: "HelveticaNeue", size: 15)
        view.isScrollEnabled = true
        view.isEditable = true
        view.isUserInteractionEnabled = true
        view.delegate = context.coordinator
        return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
           Coordinator($text)
       }
       
       class Coordinator: NSObject, UITextViewDelegate {
           var text: Binding<String>

           init(_ text: Binding<String>) {
               self.text = text
           }
           
           func textViewDidChange(_ textView: UITextView) {
               self.text.wrappedValue = textView.text
           }
       }
}

struct CreatePostView_Previews: PreviewProvider {
    
    @State static var showCreatePostView = true
    
    static var previews: some View {
        CreatePostView(userLoggedIn: User(), showCreatePostView: $showCreatePostView)
    }
}
