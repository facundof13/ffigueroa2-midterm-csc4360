//
//  ContentView.swift
//  Chat app csc4360
//
//  Created by Facundo Figueroa on 2/28/22.
//

import SwiftUI
import Combine
struct MessageView: View {
    
    var conversation : Conversation
    
    @State var composedMessage : String = ""
    @EnvironmentObject var avm : AuthenticationViewModel
    @StateObject var messageViewModel = MessageViewModel()
    @StateObject var chatUserViewModel = ChatUserViewModel()
    @State private var scrollTarget: Int?
    @State private var showActionSheet : Bool = false
    
    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView {
                LazyVStack {
                    ForEach(messageViewModel.messages ?? [], id: \.uid) { message in
                        HStack {
                            if message.senderId != self.avm.user!.uid! {
                                Group {
                                    Text(message.senderInitial ?? "")
                                    Text(message.text!)
                                        .bold()
                                        .foregroundColor(.white)
                                        .padding(10)
                                        .background(.gray)
                                        .cornerRadius(10)
                                        .id(message.uid)
                                    Spacer()
                                }
                            } else {
                                Group {
                                    Spacer()
                                    Text(message.text!)
                                        .bold()
                                        .foregroundColor(.white)
                                        .padding(10)
                                        .background(.blue)
                                        .cornerRadius(10)
                                        .id(message.uid)
                                }
                            }
                        }
                    }
                }
                .padding(.all, 10)
            }
            .onAppear {
                scrollView.scrollTo(messageViewModel.messages?.last?.uid)
            }
            .onChange(of: messageViewModel.messages?.count) { _ in
                scrollView.scrollTo(messageViewModel.messages?.last?.uid)
            }
            
            Divider()
            
            HStack {
                TextField("Message...", text: $composedMessage)
                Button(action: {
                    sendMessage()
                    scrollView.scrollTo(messageViewModel.messages?.last?.uid)
                }) {
                    Image(systemName: "arrow.up.message.fill")
                        .clipShape(Circle())
                }
            }.padding(.horizontal, 16)
        }
        .onAppear {
            messageViewModel.getMessages(conversation: self.conversation)
        }
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Leave Review", action: {
                    self.showActionSheet = true
                })
                    .actionSheet(isPresented: $showActionSheet, content: getActionSheet)
            }
        }
        
    }
    
    func getActionSheet() -> ActionSheet {
        
        let zero: ActionSheet.Button = .default(Text("0 Stars"), action: {leaveReview(rating: 0)})
        let one: ActionSheet.Button = .default(Text("1 Stars"), action: {leaveReview(rating: 1)})
        let two: ActionSheet.Button = .default(Text("2 Stars"), action: {leaveReview(rating: 2)})
        let three : ActionSheet.Button = .default(Text("3 Stars"), action: {leaveReview(rating: 3)})
        let four : ActionSheet.Button = .default(Text("4 Stars"), action: {leaveReview(rating: 4)})
        let five : ActionSheet.Button = .default(Text("5 Stars"), action: {leaveReview(rating: 5)})
        
        return ActionSheet(
            title: Text("Review"),
            message: Text("Leave a review for the users in this conversation. If you have previously left a review then leaving another review will overwrite the previous one."),
            buttons: [
                zero,one,two,three,four,five,
                    .cancel(),
            ])
    }
    
    func leaveReview(rating: Int) {
        
        for reviewedId in conversation.users! {
            if reviewedId != avm.user!.uid! {
                self.chatUserViewModel.postRating(review: Review(reviewerId: avm.user!.uid!, reviewedId: reviewedId, rating: rating))
            }
        }
        
//        self.chatUserViewModel.postRating(review: Review(reviewerId: avm.user!.uid!, reviewedId: conversation.users!.filter({ users  in
//            !users.contains(avm.user!.uid!)
//        }), rating: rating))
    }
    
    func sendMessage() {
        let newMessage = Message(text: composedMessage, senderId: self.avm.user!.uid!, conversationId: conversation.uid!, timestamp: Date(), senderInitial: self.avm.user!.initials!)
        
        messageViewModel.sendMessage(message: newMessage, conversation: self.conversation)
        
        composedMessage = ""
    }
}
