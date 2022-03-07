//
//  AuthenticationViewModel.swift
//  Chat app csc4360
//
//  Created by Facundo Figueroa on 3/1/22.
//

import Foundation
import Firebase
import GoogleSignIn
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

class AuthenticationViewModel: ObservableObject {
    enum SignInState{
        case signedIn
        case signedOut
    }
    
    @Published var state: SignInState = .signedOut
    @Published var error: String = ""
    @Published var user: ChatUser?
    
    private var db = Firestore.firestore()
    
    private var userViewModel = UserViewModel()
    
    @MainActor
    func signInWithEmail(email: String, password: String) async -> String? {
        var err : String = ""
        
        do {
            let signedInUser = try await Auth.auth().signIn(withEmail: email, password: password)
            
            self.state = .signedIn
            
            let document = try await db.collection("user").document(signedInUser.user.uid).getDocument()
            self.user = try document.data(as: ChatUser.self)
            
        }
        catch {
            err = error.localizedDescription
        }
        
        return err
    }
    
    func signIn() {
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn{ [unowned self] user, error in
                authenticateUser(for: user, with: error)
            }
        } else {
            guard let clientID = FirebaseApp.app()?.options.clientID else {return}
            
            let configuration = GIDConfiguration(clientID: clientID)
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {return}
            guard let rootViewController = windowScene.windows.first?.rootViewController else {return}
            
            GIDSignIn.sharedInstance.signIn(with: configuration, presenting: rootViewController) { [unowned self] user, error in
                authenticateUser(for: user, with: error)
            }
        }
    }
    
    func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user?.authentication, let idToken = authentication.idToken else {return}
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) {[unowned self] (authDataResult, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                let uid = authDataResult!.user.uid
                
                self.db.collection("user").document(uid).getDocument(completion:{(documentSnapshot, error) in
                    
                    if error != nil {
                        print(error!.localizedDescription)
                    } else {
                        let data = documentSnapshot!.data()
                        
                        let email = authDataResult!.user.email!
                        let displayName = authDataResult!.user.displayName!
                        
                        self.user = ChatUser(displayName: displayName, email: email, uid: uid)
                        
                        
                        if (data == nil) {
                            do {
                                try db.collection("user").document(uid).setData(from: self.user)
                            } catch {
                                print(error.localizedDescription)
                            }
                        } else {
                            self.state = .signedIn
                        }
                    }
                    
                    
                })
                
                
            }
        }
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        
        do {
            try Auth.auth().signOut()
            
            self.state = .signedOut
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func register(user: ChatUser, password: String) async -> String? {
        do {
            try await Auth.auth().createUser(withEmail: user.email, password: password)
            
            user.uid = Auth.auth().currentUser!.uid
            
            userViewModel.saveUser(newUser: user)
            
            self.state = .signedIn
            
            
            
        } catch {
            return error.localizedDescription
        }
        
        return ""
    }
    
    
    
    
}
