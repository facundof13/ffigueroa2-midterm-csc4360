//
//  Conversation.swift
//  Chat app csc4360
//
//  Created by Facundo Figueroa on 3/6/22.
//

import Foundation
import FirebaseFirestoreSwift


class Conversation: Identifiable, Codable {    
    @DocumentID public var uid: String?
    public var users: [String]?
    public var creationDate: Date?
    public var messages: [Message]?
    public var userDisplayNames: [String]?

    init(users: [String], creationDate: Date, userDisplayNames: [String]) {
        self.users = users
        self.creationDate = creationDate
        self.messages = []
        self.userDisplayNames = userDisplayNames
    }
    
}

