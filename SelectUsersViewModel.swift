//
//  SelectUsersViewModel.swift
//  Chat app csc4360
//
//  Created by Facundo Figueroa on 3/6/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class SelectUsersViewModel: ObservableObject {
    private var db = Firestore.firestore()

    @Published var otherUsers : [ChatUser]?
    @Published var completed = false
    
    func fetchUsers(avm : AuthenticationViewModel) {
        if (avm.user == nil) {
            return
        }
        
        db.collection("user")
            .addSnapshotListener({querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    return
                }
                
                do {
                    self.otherUsers = try documents
                        .filter{$0.documentID != avm.user!.uid}
                    .compactMap{ document -> ChatUser in
                        return try document.data(as: ChatUser.self)
                }
                    
                    
                }catch{
                    print(error)
                }
            })
    }
    
    func createConversation(avm: AuthenticationViewModel, users: [String], displayNames: [String]) {
        print(users)
        
        db.collection("conversation").getDocuments { (querySnapshot, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            let allConversations = querySnapshot!.documents.compactMap{ document -> Conversation in
                return try! document.data(as: Conversation.self)}
            
            if allConversations.filter({ conversation in
                return conversation.users!.count == users.count && conversation.users!.sorted() == users.sorted()
            }).count > 0 {
                print("conversation exists, not creating")
                return
            } else {
                print("conversation does not exist")
                let conversation = Conversation(users: users, creationDate: Date(), userDisplayNames: displayNames)
                
                do {
                    try self.db.collection("conversation").document().setData(from: conversation) { error in
                        if error != nil {
                            print(error!.localizedDescription)
                        }
                        return
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
    }
}


extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}
