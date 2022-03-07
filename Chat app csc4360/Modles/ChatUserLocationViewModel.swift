//
//  ChatUserLocationViewModel.swift
//  Chat app csc4360
//
//  Created by Facundo Figueroa on 3/7/22.
//

import Foundation
import FirebaseFirestore
import MapKit

class ChatUserLocationViewModel : ObservableObject {
    @Published var location : ChatUserLocation?
    @Published var region: MKCoordinateRegion?
    private var db = Firestore.firestore()
    
    
    func saveUserLocation(chatUser: ChatUser, location: CLLocationCoordinate2D) {
        let newChatUserLocation = ChatUserLocation(userId: chatUser.uid!, latitude: location.latitude, longitude: location.longitude)
        
        db.collection("locations").whereField("userId", isEqualTo: chatUser.uid!).getDocuments { querySnapshot, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let documents = querySnapshot?.documents {
                documents.forEach { queryDocumentSnapshot in
                    self.db.collection("locations").document(queryDocumentSnapshot.documentID).delete()
                }
            }
            
            do {
                let _ = try self.db.collection("locations").addDocument(from: newChatUserLocation)
            } catch {
                print(error.localizedDescription)
            }
            
        }
        
    }
    
    func getLocation(chatUser: ChatUser, avm: AuthenticationViewModel) {
        do {
            
            db.collection("locations").whereField("userId", isEqualTo: chatUser.uid!).limit(to: 1).addSnapshotListener({ querySnapshot, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                if let firstDocument = querySnapshot?.documents.first {
                    do {
                        self.location = try firstDocument.data(as: ChatUserLocation.self)
                        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: self.location!.latitude!, longitude: self.location!.longitude!), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))

                        
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                }
                
            })
            
        }
    }
}
