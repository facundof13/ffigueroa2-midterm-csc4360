//
//  ProfileImage.swift
//  Chat app csc4360
//
//  Created by Facundo Figueroa on 3/7/22.
//

import Foundation
import UIKit
import FirebaseFirestoreSwift

class ProfileImage: Identifiable, Codable {
    @DocumentID public var uid: String?
    public var imageUrl: String?
    public var userUid: String?
    public var imageUid: String?
    
    init(imageUrl: String, userUid: String, imageUid : String) {
        self.imageUrl = imageUrl
        self.userUid = userUid
        self.imageUid = imageUid
    }
}
