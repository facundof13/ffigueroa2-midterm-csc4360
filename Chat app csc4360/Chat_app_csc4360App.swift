//
//  Chat_app_csc4360App.swift
//  Chat app csc4360
//
//  Created by Facundo Figueroa on 2/28/22.
//

import SwiftUI
import Firebase

@main
struct Chat_app_csc4360App: App {
    @StateObject var viewModel = AuthenticationViewModel()
    
    init() {
        setupAuthentication()
    }
    
    var body: some Scene {
        WindowGroup {
            ApplicationSwitcher()
                .environmentObject(viewModel)
                .navigationViewStyle(.stack)
        }
    }
}

struct ApplicationSwitcher : View {
    @EnvironmentObject var avm: AuthenticationViewModel
    
    var body : some View {
        switch avm.state {
        case .signedIn:
            TabView {
                NavigationView {
                    ConversationView()
                }
                .tabItem {
                    Label("Conversations", systemImage: "person.3")
                }
                
                NavigationView {
                    SearchView()
                }
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                
                if avm.user != nil {
                    NavigationView {
                        ProfileView(chatUser: avm.user!)
                    }
                    .tabItem {
                        Label("My Profile", systemImage: "person")
                    }
                }

            }
            
        case .signedOut: NavigationView {LoginView()}
        }
    }
}

extension Chat_app_csc4360App {
    private func setupAuthentication() {
        FirebaseApp.configure()
    }
}
