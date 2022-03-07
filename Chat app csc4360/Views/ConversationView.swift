//
//  MessagesView.swift
//  Chat app csc4360
//
//  Created by Facundo Figueroa on 2/28/22.
//

import SwiftUI

struct ConversationView: View {
    @EnvironmentObject var avm: AuthenticationViewModel
    @StateObject private var conversationViewModel = ConversationViewModel()
    @State private var confirmationShown : Bool = false
    
    private var formatter = RelativeDateTimeFormatter()
    
    var body: some View {
        List(conversationViewModel.conversations ?? []) { conversation in
            HStack {
                NavigationLink{
                    MessageView(conversation: conversation)
                } label: {
                    VStack {
                        Text(conversation.userDisplayNames!.joined(separator: ", "))
                        Text(self.formatter.localizedString(for: conversation.creationDate!, relativeTo: Date()))
                    }
                    
                }
            }
        }
        .navigationTitle("Conversations")
        .toolbar {
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action:{
                    confirmationShown = true
                }) {
                    HStack {
                        Image(systemName: "arrow.left.circle.fill")
                        Text("Logout")
                    }
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: SelectUsersView()) {
                    Image(systemName:"square.and.pencil")
                }
            }
           
            
        }
        .alert("Are you sure you want to sign out?", isPresented: $confirmationShown) {
            Button(role: .destructive, action:{
                confirmationShown = false
                avm.signOut()
            }) {
                Text("Yes")
            }
        }
        .onAppear(perform:{conversationViewModel.getConversations(avm: avm)})
    }
    
}
