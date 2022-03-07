//
//  ChatUserLocation.swift
//  Chat app csc4360
//
//  Created by Facundo Figueroa on 3/7/22.
//

import Foundation
import FirebaseFirestoreSwift

class ChatUserLocation: Identifiable, Codable {
    @DocumentID public var uid: String?
    public var userId: String?
    public var latitude: Double?
    public var longitude: Double?

    init(userId: String, latitude: Double, longitude: Double) {
        self.userId = userId
        self.latitude = latitude
        self.longitude = longitude
    }
    
}
