//
//  UserViewModel.swift
//  Chat app csc4360
//
//  Created by Facundo Figueroa on 3/6/22.
//

import Foundation
import FirebaseFirestore

class UserViewModel {
    @Published var user : ChatUser?
    
    private var db = Firestore.firestore()
    
    func saveUser(newUser: ChatUser) {
        do {
            try db.collection("user").document(newUser.uid!).setData(from: newUser)
        } catch {
            print(error.localizedDescription)
        }
    }
}
