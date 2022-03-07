//
//  MessageViewModel.swift
//  Chat app csc4360
//
//  Created by Facundo Figueroa on 3/6/22.
//

import Foundation
import FirebaseFirestore

class MessageViewModel : ObservableObject {
    private var db = Firestore.firestore()
    @Published var messages : [Message]?
    
    func sendMessage(message : Message, conversation : Conversation) {
        do {
            
            let _ = try db.collection("messages").addDocument(from: message) { error in
                if error != nil {
                    print(error!.localizedDescription)
                }
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getMessages(conversation : Conversation) {
        db.collection("messages").whereField("conversationId", isEqualTo: conversation.uid!).addSnapshotListener { querySnapshot, error in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                
                guard let documents = querySnapshot?.documents else {
                    return
                }
                
                do {
                    self.messages = try documents
                        .compactMap{ document -> Message in
                            return try document.data(as: Message.self)
                        }.sorted(by: {
                            $0.timestamp.compare($1.timestamp) == .orderedAscending
                        })
                    
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
        
    }
}
