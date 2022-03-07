//
//  User.swift
//  Chat app csc4360
//
//  Created by Facundo Figueroa on 3/6/22.
//

import Foundation
import FirebaseFirestoreSwift

class ChatUser: Identifiable, Codable, Equatable {
    @DocumentID public var uid: String?
    public var displayName: String
    public var email: String
    public var initials : String?
    
    
    init(displayName: String, email: String) {
        self.displayName = displayName
        self.email = email
        self.initials = self.getInitials(displayName: displayName)
    }
    
    init (displayName: String, email: String, uid: String) {
        self.displayName = displayName
        self.email = email
        self.uid = uid
        self.initials = self.getInitials(displayName: displayName)
    }
    
    func getInitials(displayName : String) -> String {
        let stringInputArr = displayName.components(separatedBy:" ")
        var stringNeed = ""

        for string in stringInputArr {
            stringNeed += String(string.first!)
        }

        return stringNeed
    }


    static func ==(lhs:ChatUser, rhs:ChatUser) -> Bool { // Implement Equatable
        return lhs.uid == rhs.uid
    }
}

