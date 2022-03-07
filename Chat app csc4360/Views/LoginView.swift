//
//  LoginView.swift
//  Chat app csc4360
//
//  Created by Facundo Figueroa on 2/28/22.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct LoginView: View {
    @EnvironmentObject var avm: AuthenticationViewModel
    @State var email = ""
    @State var password = ""
    @State private var confirmationShown = false
    @State private var errorMessage : String = ""
    
    let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
    
    var body: some View {
        VStack {
            Text("ourChat")
                .font(.largeTitle)
                .padding(.bottom, 50)
            
            Text("Welcome")
                .font(.title)
            
            Text("Please sign in")
                .font(.title2)
                .padding(.bottom)
            
            TextField("Email", text: $email)
                .padding()
                .background(lightGreyColor)
                .cornerRadius(5.0)
            
            SecureField("Password", text: $password)
                .padding()
                .background(lightGreyColor)
                .cornerRadius(5.0)
            
            HStack {
                Button(action: {
                    Task {
                        await login()
                    }
                }) {
                    Text("Sign In")
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .frame(minWidth: 0, maxWidth: .infinity)
                }
                .frame(width: UIScreen.main.bounds.width)
            }
            
            Button(action: avm.signIn) {
                Text("Or Sign in with Google")
                    .padding()
                    .background(.white)
                    .foregroundColor(.gray)
                    .clipShape(Capsule())
                    .overlay(Capsule(style: .continuous)
                                .stroke(.gray, style: StrokeStyle(lineWidth: 2)))
            }
            
            Spacer()
            
            NavigationLink(destination: RegisterView()) {
                Text("Register")
            }
        }
        .padding()
        .alert(self.errorMessage, isPresented: $confirmationShown) {}
        
    }
    
    func login() async {
        let signedInSuccessfully = await avm.signInWithEmail(email: email, password: password)
        
        if !signedInSuccessfully!.isEmpty {
            self.confirmationShown = true
            self.errorMessage = signedInSuccessfully!
        }
    }
}
