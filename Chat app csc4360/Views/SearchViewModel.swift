//
//  SearchViewModel.swift
//  Chat app csc4360
//
//  Created by Facundo Figueroa on 3/7/22.
//

import Foundation
import FirebaseFirestore

class SearchViewModel: ObservableObject {
    private var db = Firestore.firestore()
    @Published var searchResults : [ChatUser]?
    
    func search(input: String, avm: AuthenticationViewModel) {
        db.collection("user")
            .addSnapshotListener({querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    return
                }
                
                do {
                    self.searchResults = try documents
                        .filter{$0.documentID != avm.user!.uid}
                        .compactMap{ document -> ChatUser in
                            return try document.data(as: ChatUser.self)
                        }
                        .filter{$0.displayName.lowercased().contains(input.lowercased())}
                    
                    
                }catch{
                    print(error)
                }
            })
        
    }
}
