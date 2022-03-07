//
//  ConversationViewModel.swift
//  Chat app csc4360
//
//  Created by Facundo Figueroa on 3/6/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

class ConversationViewModel: ObservableObject {
    @Published var conversations: [Conversation]?
    private var db = Firestore.firestore()
    
    func getConversations(avm: AuthenticationViewModel) {
        if (avm.user == nil) {
            return
        }
        
        db.collection("conversation").whereField("users", arrayContainsAny: [avm.user!.uid!]).addSnapshotListener({querySnapshot, error in
        
            guard let documents = querySnapshot?.documents else {
                return
            }
            
            do {
                self.conversations = try documents
                .compactMap{ document -> Conversation in
                    return try document.data(as: Conversation.self)
            }
            }catch{
                print(error)
            }
            
        })
    }
}
