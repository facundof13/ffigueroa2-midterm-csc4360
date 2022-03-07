//
//  ProfileView.swift
//  Chat app csc4360
//
//  Created by Facundo Figueroa on 3/7/22.
//

import SwiftUI
import CoreLocationUI
import MapKit

struct ProfileView: View {
    var chatUser : ChatUser
    @EnvironmentObject var avm : AuthenticationViewModel
    @StateObject var chatUserViewModel = ChatUserViewModel()
    @StateObject var chatUserLocationViewModel = ChatUserLocationViewModel()
    @State private var showImagePicker: Bool = false
    @State private var inputImage : UIImage?
    @State private var image : Image?
    @State var isSelfState: IsSelf = .no
    @StateObject var locationManager = LocationManager()
    @State var region : MKCoordinateRegion?
    @State private var confirmationShown : Bool = false
    
    enum IsSelf {
        case yes
        case no
    }
    
    var body: some View {
        VStack {
            if self.chatUserViewModel.uiImage != nil {
                Image(uiImage: chatUserViewModel.uiImage!)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 100, alignment: .center)
                    .clipShape(Circle())
            }
            
            HStack {
                Text("Email:")
                Text(chatUser.email)
            }
            .padding()
            
            List {
                HStack {
                    Text("Rating")
                    Spacer()
                    if chatUserViewModel.review == nil {
                        Text("No rating yet")
                    } else {
                        Text(chatUserViewModel.review!.description)
                    }
                }
                if chatUserLocationViewModel.location != nil {
                    HStack {
                        Map(coordinateRegion: Binding(get: {chatUserLocationViewModel.region!}, set: { chatUserLocationViewModel.region! = $0 }))
                            .frame(height: 200, alignment: .center)
                    }
//                    .onChange(of: locationManager.location) { newValue in
//                        if let location = newValue {
//                            chatUserLocationViewModel.saveUserLocation(chatUser: chatUser, location: location)
//                        }
//                    }
                }
                
                
            }
            VStack {
                if isSelfState == .yes {
                    
                    Button("Upload a profile picture") {
                        self.showImagePicker = true
                    }
                    .padding()
                    
                    LocationButton(.shareMyCurrentLocation) {
                        locationManager.requestLocation(chatUser: chatUser)
                    }
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
                }
            }
            Spacer()
            
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if isSelfState == .yes {
                    Button(action:{
                        confirmationShown = true
                    }) {
                        HStack {
                            Text("Logout")
                            Image(systemName: "arrow.right.circle.fill")
                        }
                    }
                }
            }
        }
        .navigationTitle(Text(chatUser.displayName))
        .onAppear {
            if chatUser.uid == avm.user?.uid {
                isSelfState = .yes
            }
            
            chatUserViewModel.getRating(chatUser: chatUser, avm: avm)
            self.inputImage = chatUserViewModel.getProfileImage(chatUser: chatUser)
            chatUserLocationViewModel.getLocation(chatUser: chatUser, avm: avm)
        }
        .onChange(of: self.inputImage) { _ in
            Task {
                uploadImage()
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $inputImage)
        }
        .alert("Are you sure you want to sign out?", isPresented: $confirmationShown) {
            Button(role: .destructive, action:{
                confirmationShown = false
                avm.signOut()
            }) {
                Text("Yes")
            }
        }
    }
    
    func uploadImage() {
        guard let inputImage = inputImage else { return }
        //        self.image = Image(uiImage: inputImage)
        self.chatUserViewModel.uploadImage(image: inputImage, avm: avm)
        
        
    }
}
