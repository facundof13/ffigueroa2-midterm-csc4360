//
//  Message.swift
//  Chat app csc4360
//
//  Created by Facundo Figueroa on 3/6/22.
//

import Foundation
import FirebaseFirestoreSwift

class Message: Hashable, Identifiable, Codable, Equatable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.uid == rhs.uid
    }
    
    @DocumentID public var uid: String?
    public var text: String?
    public var senderId: String?
    public var imageUrl: String?
    public var conversationId: String?
    public var timestamp: Date
    public var senderInitial: String?
    
    init(text : String, senderId : String, conversationId : String, timestamp : Date, senderInitial : String) {
        self.text = text
        self.senderId = senderId
        self.conversationId = conversationId
        self.timestamp = timestamp
        self.senderInitial = senderInitial
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }

}
