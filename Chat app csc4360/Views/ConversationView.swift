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

    
    private var formatter = RelativeDateTimeFormatter()
    
    var body: some View {
        List(conversationViewModel.conversations ?? []) { conversation in
            HStack {
                NavigationLink{
                    MessageView(conversation: conversation)
                } label: {
                    VStack {
                        Text(conversation.userDisplayNames!.joined(separator: ", "))
                            .padding(.all, 5)
                        Text(self.formatter.localizedString(for: conversation.creationDate!, relativeTo: Date()))
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
