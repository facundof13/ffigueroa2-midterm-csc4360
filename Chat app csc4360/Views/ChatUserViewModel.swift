//
//  ChatUserViewModel.swift
//  Chat app csc4360
//
//  Created by Facundo Figueroa on 3/7/22.
//

import Foundation
import FirebaseFirestore

class ChatUserViewModel:ObservableObject {
    
    private var db = Firestore.firestore()
    @Published var review : Int?
    
    func getRating(chatUser: ChatUser, avm: AuthenticationViewModel) {
        db.collection("rating").whereField("reviewedId", isEqualTo: chatUser.uid!)
            .addSnapshotListener({querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    return
                }
                
                do {
                    let ratings = try documents
                        .compactMap{ document -> Review in
                            return try document.data(as: Review.self)
                        }.map{$0.rating!}
                    
                    if ratings.count > 0 {
                        self.review = (ratings.reduce(0, +) / ratings.count)
                    } else {
                        self.review = nil
                    }
                }catch{
                    print(error)
                }
            })
    }
    
    func postRating(review: Review) {
        print(review)
        do {
            try db.collection("rating").document().setData(from: review) { error in
                if error != nil {
                    print(error!.localizedDescription)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
    }
}
