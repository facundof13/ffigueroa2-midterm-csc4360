//
//  SearchView.swift
//  Chat app csc4360
//
//  Created by Facundo Figueroa on 3/7/22.
//

import SwiftUI

struct SearchView: View {
    @State private var text : String = ""
    @EnvironmentObject var avm : AuthenticationViewModel
    @StateObject private var searchViewModel = SearchViewModel()
    
    var body: some View {
        VStack {
            TextField("Search for user", text: $text)
                .padding(.all, 10)
                .autocapitalization(.none)
                .onChange(of: text) { newValue in
                    searchViewModel.search(input: newValue, avm: avm)
                }
            List(searchViewModel.searchResults ?? []) { chatUser in
                NavigationLink(chatUser.displayName, destination: ChatUserView(chatUser: chatUser))
                
            }
            .navigationTitle("Search")
            .onAppear {
                searchViewModel.search(input: "", avm: avm)
            }
        }
    }
}

