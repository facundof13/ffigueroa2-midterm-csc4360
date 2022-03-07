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

    
    var body: some View {
        List(conversationViewModel.conversations ?? []) { conversation in
            HStack {
                NavigationLink{
                    MessageView(conversation: conversation)
                } label: {
                    VStack {
                        Text(conversation.userDisplayNames!.filter { $0 != avm.user?.displayName }.sorted().joined(separator: ", "))
                            .padding(.all, 5)
                    }
                }
            }
        }
        .navigationTitle("Conversations")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: SelectUsersView()) {
                    Image(systemName:"square.and.pencil")
                }
            }   
        }
        .onAppear(perform:{conversationViewModel.getConversations(avm: avm)})
    }
    
}
