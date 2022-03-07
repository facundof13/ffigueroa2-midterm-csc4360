//
//  SelectUsersView.swift
//  Chat app csc4360
//
//  Created by Facundo Figueroa on 3/6/22.
//

import SwiftUI

struct SelectUsersView: View {
    @EnvironmentObject var avm: AuthenticationViewModel
    @StateObject private var selectUsersViewModel = SelectUsersViewModel()
    @State var selectedUsers : [ChatUser]? = []
    @State var goWhenTrue : Bool = false
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        VStack {
        List(selectUsersViewModel.otherUsers ?? []) { chatUser in
            if selectUsersViewModel.otherUsers!.count > 0 {
                MultipleSelectionRow(title: chatUser.displayName, isSelected: selectedUsers!.contains(chatUser)) {
                    if selectedUsers!.contains(chatUser) {
                        let index = selectedUsers!.firstIndex(of: chatUser)
                        selectedUsers!.remove(at: index!)
                    }
                    else {
                        selectedUsers!.append(chatUser)
                    }
                }
            }
        }
        .onAppear(perform: {
            selectUsersViewModel.fetchUsers(avm: self.avm)
            
            DispatchQueue.main.async {
                self.presentation.wrappedValue.dismiss()
            }
            
        })
    
            Button(action:{
                startConversation()
                
            }) {
                Text("Start conversation")
            }.disabled(selectedUsers!.count <= 0)
                .padding()
            
        }
    }
    
    func startConversation() {
        let userId = avm.user!.uid
        var userIds = self.selectedUsers!.map { $0.uid! }
        userIds.append(userId!)
        
        let displayName = avm.user!.displayName
        var displayNames = self.selectedUsers!.map {$0.displayName}
        displayNames.append(displayName)
        
        selectUsersViewModel.createConversation(avm: avm, users: userIds, displayNames: displayNames)
    }
}

struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(self.title)
                if self.isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}

