//
//  ChatUserViewModel.swift
//  Chat app csc4360
//
//  Created by Facundo Figueroa on 3/7/22.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseStorageCombineSwift
import UIKit
import CoreMedia

class ChatUserViewModel:ObservableObject {
    
    private var db = Firestore.firestore()
    let storage = Storage.storage()
    @Published var uiImage : UIImage?
    @Published var review : Int?
    private let googleURL = "gs://chat-app-d9e86.appspot.com/"
    
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
                    print(error.localizedDescription)
                }
            })
    }
    
    func postRating(review: Review) {
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
    
    func getProfileImage(chatUser: ChatUser) -> UIImage {
        if let userId = chatUser.uid {
            do {
                try db.collection("images").whereField("userUid", isEqualTo: chatUser.uid!).limit(to: 1).addSnapshotListener({ querySnapshot, error in
                    if let firstDocument = querySnapshot?.documents.first {
                        let profileImage = try! firstDocument.data(as: ProfileImage.self)
                        
                        let uiImage = UIImage(data: try! Data(contentsOf: URL(string: profileImage.imageUrl!)!))
                        self.uiImage = uiImage
                    }
                })
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return UIImage()
    }
    
    func uploadImage(image: UIImage, avm : AuthenticationViewModel) {
        let imageId = UUID().uuidString
        let storageRef = storage.reference().child("images/\(imageId)")
        let data = image.jpegData(compressionQuality: 0.2)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        
        if let data = data {
            storageRef.putData(data, metadata: metadata) { [self](metadata, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                if metadata != nil {
                    let _: Void = storage.reference(forURL: "\(self.googleURL)/images/\(imageId)")
                        .downloadURL { url, error in
                            if let error = error {
                                print(error.localizedDescription)
                            } else {
                                let urlString = url!.absoluteString
                                let profileImage = ProfileImage(imageUrl: urlString, userUid: avm.user!.uid!, imageUid: imageId)
                                
                                do {
                                    
                                    db.collection("images").whereField("userUid", isEqualTo: avm.user!.uid!).getDocuments(completion: { querySnapshot, error in
                                        if let error = error {
                                            print(error.localizedDescription)
                                            return
                                        }
                                        
                                        if let querySnapshot = querySnapshot {
                                            
                                            print(querySnapshot.documents.count)
                                            
                                            if !querySnapshot.documents.isEmpty {
                                                
                                                querySnapshot.documents.forEach { queryDocumentSnapshot in
                                                    let pImage = try! queryDocumentSnapshot.data(as: ProfileImage.self)
                                                    
                                                    if let url = pImage.imageUrl {
                                                        let reference = storage.reference(forURL: url)
                                                        reference.delete { error in
                                                            if let error = error {
                                                                print(error.localizedDescription)
                                                            }
                                                        }
                                                    }
                                                    
                                                    
                                                    db.collection("images").document(queryDocumentSnapshot.documentID).delete { error in
                                                        if let error = error {
                                                            print(error.localizedDescription)
                                                        } else {
                                                            do {
                                                                let _ = try db.collection("images").addDocument(from: profileImage)
                                                            } catch {
                                                                print(error.localizedDescription)
                                                            }
                                                        }
                                                    }
                                                }
                                                
                                            } else {
                                                do {
                                                    let _ = try db.collection("images").addDocument(from: profileImage)
                                                } catch {
                                                    print(error.localizedDescription)
                                                }
                                            }
                                        }
                                    })
                                }
                            }
                        }
                }
            }
            
        }
    }
}
