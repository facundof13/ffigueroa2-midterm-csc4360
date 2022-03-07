//
//  ChatController.swift
//  Chat app csc4360
//
//  Created by Facundo Figueroa on 2/28/22.
//

import Combine
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift


class ChatController : ObservableObject {
    var didChange = PassthroughSubject<Void, Never>()
//    private var db
    
    
    
    @Published var messages = [
        ChatMessage(message: "Hello world", avatar: "A", color: .red),
        ChatMessage(message: "Hi!", avatar: "B", color: .blue, isMe: true),
    ]
    
    func sendMessage(_ chatMessage: ChatMessage) {
        messages.append(chatMessage)
        didChange.send(())
    }
    
    func getMessages() {
        
    }
}
