//
//  Review.swift
//  Chat app csc4360
//
//  Created by Facundo Figueroa on 3/7/22.
//

import Foundation
import FirebaseFirestoreSwift


class Review: Identifiable, Codable {
    @DocumentID public var uid: String?
    public var reviewerId: String?
    public var reviewedId: String?
    public var rating: Int?

    init(reviewerId: String, reviewedId: String, rating: Int) {
        self.reviewerId = reviewerId
        self.reviewedId = reviewedId
        self.rating = rating        
    }
    
}
