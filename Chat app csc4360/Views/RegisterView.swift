//
//  RegisterView.swift
//  Chat app csc4360
//
//  Created by Facundo Figueroa on 3/1/22.
//

import SwiftUI
import FirebaseAuthCombineSwift

struct RegisterView: View {
    @EnvironmentObject var avm: AuthenticationViewModel
    let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
    @State var email = ""
    @State var password = ""
    @State var displayName = ""
    @State var message = ""
    @State private var displayError : Bool = false
    
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        VStack {
            Text("Please create an account")
                .font(.title2)
                .padding(.bottom, 100)
                .frame(alignment: .leading)
            
            TextField("Display Name", text: $displayName)
                .padding()
                .background(lightGreyColor)
                .cornerRadius(5.0)
            
            TextField("Email", text: $email)
                .padding()
                .background(lightGreyColor)
                .cornerRadius(5.0)
            
            SecureField("Password", text: $password)
                .padding()
                .background(lightGreyColor)
                .cornerRadius(5.0)
            
            Button(action:{Task{await signup()}}) {
                Text("Sign up")
            }
            
            Spacer()
        }
        .padding()
        .alert(!message.isEmpty ? message : "Your input is not valid. Please correct your information and try again.", isPresented: $displayError) {}
        .navigationTitle("Register")
    }
    
    func signup() async {
        if (!validateForm()) {
            displayError = true
        } else {
            let newUser = ChatUser(displayName: displayName, email: email)
            let error = await avm.register(user: newUser, password: password)
            
            if !error!.isEmpty {
                displayError = true
                message = error!
            } else {
                DispatchQueue.main.async {
                    self.presentation.wrappedValue.dismiss()
                }
                
            }
        }
        
    }
    
    func validateForm() -> Bool {
        if !email.contains("@") {
            return false
        }
        
        if password.count < 8 {
            return false
        }
        
        if password.isEmpty || email.isEmpty || displayName.isEmpty {
            return false
        }
        
        return true
        
        
    }
}
