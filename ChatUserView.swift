//
//  ChatUserView.swift
//  Chat app csc4360
//
//  Created by Facundo Figueroa on 3/7/22.
//

import SwiftUI

struct ChatUserView: View {
    
    var chatUser : ChatUser
    @StateObject var chatUserViewModel = ChatUserViewModel()
    @EnvironmentObject var avm : AuthenticationViewModel
    
    var body: some View {
        VStack {
            if chatUserViewModel.review != nil{
                Text("This user has an average review of:")
                Text(chatUserViewModel.review!.description)
            } else {
                Text("This user has no reviews")
            }
            Spacer()
        }
        .navigationTitle(chatUser.displayName)
        .onAppear {
            chatUserViewModel.getRating(chatUser: chatUser, avm: avm)
        }
    }
}
