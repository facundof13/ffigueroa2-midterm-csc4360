//
//  ProfileView.swift
//  Chat app csc4360
//
//  Created by Facundo Figueroa on 3/7/22.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var avm : AuthenticationViewModel
    @StateObject var chatUserViewModel = ChatUserViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Text("Email:")
                Text(avm.user?.email ?? "")
            }
            .padding()
            
            if chatUserViewModel.review == nil {
                Text("You do not currently have a rating")
            } else {
                Text("Your rating is currently at an average of:")
                Text(chatUserViewModel.review!.description)
            }
            
            Spacer()
        }
        .navigationTitle(Text(avm.user?.displayName ?? ""))
        .onAppear {
            chatUserViewModel.getRating(chatUser: avm.user!, avm: avm)
        }
    }
}
